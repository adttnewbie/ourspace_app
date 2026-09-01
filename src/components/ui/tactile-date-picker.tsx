import { CalendarHeart, ChevronLeft, ChevronRight, X } from "lucide-react-native";
import { useEffect, useState } from "react";
import { Modal, Pressable, Text, View } from "react-native";
import { WashiTape } from "./washi-tape";

const C = { ink: "#1B1C1A", pink: "#FFD9E3", yellow: "#EEE199", error: "#ba1a1a", errorBg: "#ffdad6" };
const MONTHS = ["Januari","Februari","Maret","April","Mei","Juni","Juli","Agustus","September","Oktober","November","Desember"];
const MONTHS_SHORT = ["JAN","FEB","MAR","APR","MEI","JUN","JUL","AGU","SEP","OKT","NOV","DES"];

function startOfMonth(d: Date) { return new Date(d.getFullYear(), d.getMonth(), 1); }
function daysInMonth(d: Date) { return new Date(d.getFullYear(), d.getMonth()+1, 0).getDate(); }

export function TactileDateField({ value, onChange, error, placeholder="Pilih tanggal" }: { value: string; onChange: (v: string)=>void; error?: string; placeholder?: string }) {
  const [open, setOpen] = useState(false);
  const [cursor, setCursor] = useState(() => { const now=new Date(); return new Date(now.getFullYear(), now.getMonth(), 1); });

  // sync cursor ketika value berubah atau modal dibuka
  useEffect(() => {
    if (value && open) {
      const [d,m] = value.split(" ");
      const mi = MONTHS_SHORT.indexOf(m);
      if (mi >= 0) setCursor(new Date(new Date().getFullYear(), mi, 1));
    }
  }, [value, open]);

  const selected = value ? (()=>{ const [d,m]=value.split(" "); const mi=MONTHS_SHORT.indexOf(m); if(mi>=0) return {d:parseInt(d), m:mi}; return null })() : null;
  const firstDay = startOfMonth(cursor).getDay();
  const dim = daysInMonth(cursor);
  const offset = (firstDay + 6) % 7;
  const cells: (number|null)[] = [...Array(offset).fill(null), ...Array.from({length: dim}, (_,i)=>i+1)];
  while (cells.length % 7 !== 0) cells.push(null);

  const pick = (day: number) => {
    const label = `${String(day).padStart(2,"0")} ${MONTHS_SHORT[cursor.getMonth()]}`;
    onChange(label);
    setOpen(false);
  };

  return (
    <>
      <Pressable
        onPress={() => setOpen(true)}
        className="flex-row items-end gap-2 border-b-[1.6px] pb-2 pt-1"
        style={{ borderColor: error ? C.error : C.ink }}
        accessibilityRole="button"
        accessibilityLabel="Pilih tanggal"
      >
        <View className="w-8 h-8 rounded-[8px] border border-[#1B1C1A] items-center justify-center" style={{ backgroundColor: value ? C.pink : "#fff" }}>
          <CalendarHeart size={14} color={C.ink} strokeWidth={1.8} />
        </View>
        <View className="flex-1">
          <Text className="text-[11px] font-bold tracking-[0.6px]" style={{ fontFamily:"Space Mono", color: error ? C.error : "#837377" }}>TANGGAL</Text>
          <Text className="text-[15px] font-bold mt-0.5" numberOfLines={1} style={{ fontFamily:"Bricolage Grotesque", color: value ? C.ink : "#B8A9AC" }}>{value || placeholder}</Text>
        </View>
        <View className="w-7 h-7 rounded-full bg-[#FDFCF8] border border-[#1B1C1A] items-center justify-center">
          <ChevronRight size={12} color={C.ink} strokeWidth={2} />
        </View>
      </Pressable>
      {error && <Text className="text-[11px] mt-1" style={{ fontFamily:"Space Mono", color:C.error }}>{error}</Text>}

      <Modal visible={open} transparent animationType="slide" onRequestClose={()=>setOpen(false)} statusBarTranslucent>
        <View className="flex-1 bg-[#1B1C1A]/40 justify-end">
          <Pressable className="flex-1" onPress={()=>setOpen(false)} />
          <View className="bg-[#FDFCF8] rounded-t-[20px] border-t-[1.5px] border-x-[1.5px] border-[#1B1C1A] px-5 pt-5 pb-6" style={{ shadowColor:C.ink, shadowOpacity:1, shadowRadius:0, shadowOffset:{width:0,height:-4} }}>
            <View className="absolute -top-2 left-1/2 -translate-x-1/2 z-10"><WashiTape w={52} rotate="-2deg" color={C.yellow} /></View>
            <View className="w-10 h-1.5 rounded-full bg-[#1B1C1A] opacity-20 self-center mb-4" />
            <View className="flex-row items-center justify-between">
              <Text className="text-[16px] font-extrabold text-[#1B1C1A]" style={{ fontFamily:"Bricolage Grotesque" }}>Pilih tanggal</Text>
              <Pressable onPress={()=>setOpen(false)} className="w-8 h-8 rounded-full bg-white border border-[#1B1C1A] items-center justify-center" accessibilityLabel="Tutup"><X size={16} color={C.ink} /></Pressable>
            </View>
            <View className="mt-4 bg-white rounded-[16px] border-[1.5px] border-[#1B1C1A] p-3" style={{ shadowColor:C.ink, shadowOpacity:1, shadowRadius:0, shadowOffset:{width:3,height:3} }}>
              <View className="flex-row items-center justify-between">
                <Pressable onPress={()=>setCursor(new Date(cursor.getFullYear(), cursor.getMonth()-1,1))} className="w-8 h-8 rounded-full bg-[#FDFCF8] border border-[#1B1C1A] items-center justify-center" hitSlop={8}><ChevronLeft size={16} color={C.ink} /></Pressable>
                <Text className="text-[15px] font-extrabold text-[#1B1C1A]" style={{ fontFamily:"Bricolage Grotesque" }}>{MONTHS[cursor.getMonth()]} {cursor.getFullYear()}</Text>
                <Pressable onPress={()=>setCursor(new Date(cursor.getFullYear(), cursor.getMonth()+1,1))} className="w-8 h-8 rounded-full bg-[#FDFCF8] border border-[#1B1C1A] items-center justify-center" hitSlop={8}><ChevronRight size={16} color={C.ink} /></Pressable>
              </View>
              <View className="flex-row mt-3">
                {["SN","SL","RB","KM","JM","SB","MG"].map(v=>(
                  <Text key={v} className="flex-1 text-center text-[10px] font-bold text-[#837377]" style={{ fontFamily:"Space Mono" }}>{v}</Text>
                ))}
              </View>
              <View className="flex-row flex-wrap mt-2">
                {cells.map((d,i)=>{
                  const isSelected = d !== null && selected && d===selected.d && cursor.getMonth()===selected.m;
                  const isToday = d !== null && new Date().getDate()===d && new Date().getMonth()===cursor.getMonth() && new Date().getFullYear()===cursor.getFullYear();
                  return (
                    <View key={i} className="w-[14.28%] p-1">
                      {d===null ? <View className="h-9" /> : (
                        <Pressable onPress={()=>pick(d)} className="h-9 rounded-[8px] border items-center justify-center" style={{ backgroundColor: isSelected ? C.ink : isToday ? "#fff" : "#FDFCF8", borderColor: isSelected ? C.ink : isToday ? C.ink : "#E8D9E0", borderWidth: isSelected ? 1.6 : 1 }} accessibilityLabel={`Pilih tanggal ${d}`}>
                          <Text className="text-[13px] font-bold" style={{ fontFamily:"Space Mono", color: isSelected ? "#fff" : C.ink }}>{d}</Text>
                          {isSelected && <View className="absolute -top-1 -right-1 w-2 h-2 rounded-full bg-[#FFD9E3] border border-[#1B1C1A]" />}
                        </Pressable>
                      )}
                    </View>
                  );
                })}
              </View>
              <View className="mt-2 flex-row items-center gap-1.5">
                <View className="w-2 h-2 rounded-full bg-[#864D61]" /><Text className="text-[11px] text-[#514347]" style={{ fontFamily:"Space Mono" }}>Terpilih</Text>
                <View className="w-3 h-3 rounded-[4px] border border-[#1B1C1A] bg-white ml-3" /><Text className="text-[11px] text-[#514347]" style={{ fontFamily:"Space Mono" }}>Hari ini</Text>
              </View>
            </View>
            <Text className="text-center text-[11px] text-[#837377] mt-3" style={{ fontFamily:"Space Mono" }}>Tap tanggal untuk memilih — kayak melingkari kalender dinding</Text>
          </View>
        </View>
      </Modal>
    </>
  );
}
