import { useEffect, useState } from "react";
import { View, Text, Pressable, Modal, ScrollView } from "react-native";
import { Clock3, X, ChevronRight } from "lucide-react-native";
import { WashiTape } from "./washi-tape";

const C = { ink: "#1B1C1A", blue: "#B4EBFF", pink: "#FFD9E3", error: "#ba1a1a" };

export function TactileTimeField({ value, onChange, error }: { value: string; onChange: (v: string)=>void; error?: string }) {
  const [open, setOpen] = useState(false);
  const [h, setH] = useState(()=> value ? parseInt(value.split(":")[0]) : 19);
  const [m, setM] = useState(()=> value ? parseInt(value.split(":")[1]) : 30);

  useEffect(() => {
    if (value) {
      const [hh, mm] = value.split(":").map(Number);
      if (!isNaN(hh)) setH(hh);
      if (!isNaN(mm)) setM(mm);
    }
  }, [value]);

  const confirm = () => {
    const v = `${String(h).padStart(2,"0")}:${String(m).padStart(2,"0")}`;
    onChange(v);
    setOpen(false);
  };

  return (
    <>
      <Pressable onPress={()=>setOpen(true)} className="flex-row items-end gap-2 border-b-[1.6px] pb-2 pt-1" style={{ borderColor: error ? C.error : C.ink }} accessibilityLabel="Pilih jam">
        <View className="w-8 h-8 rounded-full border border-[#1B1C1A] items-center justify-center" style={{ backgroundColor: value ? C.blue : "#fff" }}>
          <Clock3 size={14} color={C.ink} strokeWidth={1.8} />
        </View>
        <View className="flex-1">
          <Text className="text-[11px] font-bold tracking-[0.6px]" style={{ fontFamily:"Space Mono", color: error ? C.error : "#837377" }}>JAM</Text>
          <Text className="text-[15px] font-bold mt-0.5" numberOfLines={1} style={{ fontFamily:"Space Mono", color: value ? C.ink : "#B8A9AC" }}>{value || "19:30"}</Text>
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
            <View className="absolute -top-2 left-1/2 -translate-x-1/2 z-10"><WashiTape w={52} rotate="2deg" color={C.blue} /></View>
            <View className="w-10 h-1.5 rounded-full bg-[#1B1C1A] opacity-20 self-center mb-4" />
            <View className="flex-row items-center justify-between">
              <Text className="text-[16px] font-extrabold text-[#1B1C1A]" style={{ fontFamily:"Bricolage Grotesque" }}>Pilih jam</Text>
              <Pressable onPress={()=>setOpen(false)} className="w-8 h-8 rounded-full bg-white border border-[#1B1C1A] items-center justify-center" accessibilityLabel="Tutup"><X size={16} color={C.ink} /></Pressable>
            </View>

            <View className="mt-4 bg-white rounded-[16px] border-[1.5px] border-[#1B1C1A] p-3 flex-row items-center justify-center gap-3" style={{ shadowColor:C.ink, shadowOpacity:1, shadowRadius:0, shadowOffset:{width:3,height:3} }}>
              <View className="w-14 h-14 rounded-full border-[1.6px] border-[#1B1C1A] items-center justify-center bg-[#FFD9E3]" style={{ transform:[{rotate:"-2deg"}] }}>
                <Text className="text-[20px] font-extrabold text-[#1B1C1A]" style={{ fontFamily:"Space Mono" }}>{String(h).padStart(2,"0")}</Text>
              </View>
              <Text className="text-[24px] font-light text-[#1B1C1A]">:</Text>
              <View className="w-14 h-14 rounded-full border-[1.6px] border-[#1B1C1A] items-center justify-center bg-[#B4EBFF]" style={{ transform:[{rotate:"2deg"}] }}>
                <Text className="text-[20px] font-extrabold text-[#1B1C1A]" style={{ fontFamily:"Space Mono" }}>{String(m).padStart(2,"0")}</Text>
              </View>
              <View className="ml-2 px-2 py-1 rounded-full bg-[#1B1C1A]">
                <Text className="text-[10px] font-bold text-white" style={{ fontFamily:"Space Mono" }}>{h < 12 ? "PAGI" : h < 18 ? "SORE" : "MALAM"}</Text>
              </View>
            </View>

            <View className="mt-4 flex-row gap-3">
              <View className="flex-1 bg-white rounded-[12px] border border-[#1B1C1A] p-2" style={{ shadowColor:C.ink, shadowOpacity:0.06, shadowRadius:0, shadowOffset:{width:2,height:2} }}>
                <Text className="text-[11px] font-bold text-center tracking-[0.6px] text-[#837377]" style={{ fontFamily:"Space Mono" }}>JAM</Text>
                <ScrollView showsVerticalScrollIndicator={false} className="h-[140px] mt-2" bounces={false}>
                  {Array.from({length:24},(_,i)=>i).map(v=>(
                    <Pressable key={v} onPress={()=>setH(v)} className="py-2 rounded-full items-center my-0.5 border" style={{ backgroundColor: h===v ? C.ink : "#fff", borderColor: h===v ? C.ink : "transparent" }} accessibilityLabel={`Jam ${v}`}>
                      <Text className="text-[14px] font-bold" style={{ fontFamily:"Space Mono", color: h===v ? "#fff" : C.ink }}>{String(v).padStart(2,"0")}</Text>
                    </Pressable>
                  ))}
                </ScrollView>
              </View>
              <View className="flex-1 bg-white rounded-[12px] border border-[#1B1C1A] p-2" style={{ shadowColor:C.ink, shadowOpacity:0.06, shadowRadius:0, shadowOffset:{width:2,height:2} }}>
                <Text className="text-[11px] font-bold text-center tracking-[0.6px] text-[#837377]" style={{ fontFamily:"Space Mono" }}>MENIT</Text>
                <ScrollView showsVerticalScrollIndicator={false} className="h-[140px] mt-2" bounces={false}>
                  {[0,5,10,15,20,25,30,35,40,45,50,55].map(v=>(
                    <Pressable key={v} onPress={()=>setM(v)} className="py-2 rounded-full items-center my-0.5 border" style={{ backgroundColor: m===v ? C.blue : "#fff", borderColor: m===v ? C.ink : "transparent", borderWidth: m===v ? 1.4 : 0 }}>
                      <Text className="text-[14px] font-bold" style={{ fontFamily:"Space Mono", color: C.ink }}>{String(v).padStart(2,"0")}</Text>
                    </Pressable>
                  ))}
                </ScrollView>
              </View>
            </View>

            <Pressable onPress={confirm} className="mt-4 bg-[#864D61] rounded-full border-[1.6px] border-[#1B1C1A] py-3 flex-row items-center justify-center gap-2 active:opacity-90" style={{ shadowColor:C.ink, shadowOpacity:1, shadowRadius:0, shadowOffset:{width:3,height:3} }}>
              <Text className="text-[14px] font-extrabold text-white" style={{ fontFamily:"Bricolage Grotesque" }}>Pakai jam {String(h).padStart(2,"0")}:{String(m).padStart(2,"0")}</Text>
              <View className="w-6 h-6 rounded-full bg-white items-center justify-center"><Clock3 size={12} color={C.ink} /></View>
            </Pressable>
          </View>
        </View>
      </Modal>
    </>
  );
}
