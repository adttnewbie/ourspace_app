import { useState } from "react";
import { View, Text, Pressable, ScrollView, TextInput } from "react-native";
import { Link } from "expo-router";
import { User, Heart, LogOut, Shield, Bell, Palette, Lock, Trash2, ChevronRight, Copy, Check, PenLine } from "lucide-react-native";
import { WashiTape } from "@/components/ui/washi-tape";

const C = { ink: "#1B1C1A", pink: "#FFD9E3", yellow: "#EEE199", blue: "#B4EBFF", mint: "#C6F0D1", error: "#ba1a1a", errorBg: "#ffdad6" };

function DoodleToggle({ value, onToggle }: { value: boolean; onToggle: () => void }) {
  return (
    <Pressable onPress={onToggle} className="w-[48px] h-[28px] rounded-full border-[1.5px] border-[#1B1C1A] p-1 flex-row items-center" style={{ backgroundColor: value ? C.ink : "#fff", justifyContent: value ? "flex-end" : "flex-start" }}>
      <View className="w-[18px] h-[18px] rounded-full border border-[#1B1C1A] items-center justify-center" style={{ backgroundColor: value ? C.pink : "#FDFCF8" }}>
        {value ? <Heart size={10} color={C.ink} fill={C.ink} strokeWidth={1.8} /> : <View className="w-2 h-[1.5px] bg-[#1B1C1A] opacity-30 rounded-full" />}
      </View>
    </Pressable>
  );
}

function HandCheckbox({ checked, onPress }: { checked: boolean; onPress: () => void }) {
  return (
    <Pressable onPress={onPress} className="w-6 h-6 rounded-[6px] border-[1.6px] border-[#1B1C1A] items-center justify-center" style={{ backgroundColor: checked ? C.ink : "#fff", transform: [{ rotate: checked ? "-1deg" : "0.5deg" }] }}>
      {checked && <Check size={12} color="#fff" strokeWidth={2.5} />}
    </Pressable>
  );
}

export default function ProfileTab() {
  const [notifKencan, setNotifKencan] = useState(true);
  const [notifHarian, setNotifHarian] = useState(false);
  const [privateMode, setPrivateMode] = useState(true);
  const [kertas, setKertas] = useState<"cream" | "pink" | "blue">("cream");
  const [namaRuang, setNamaRuang] = useState("Ruang Alya & Bima");
  const [copied, setCopied] = useState(false);

  const kertasOpts: { id: typeof kertas; label: string; hex: string; desc: string }[] = [
    { id: "cream", label: "Kertas Cream", hex: "#FDFCF8", desc: "Hangat • default" },
    { id: "pink", label: "Kertas Pink", hex: "#FFD9E3", desc: "Romantis" },
    { id: "blue", label: "Kertas Biru", hex: "#B4EBFF", desc: "Tenang" },
  ];

  return (
    <View className="flex-1 bg-[#FDFCF8] overflow-hidden">
      <View pointerEvents="none" className="absolute inset-0 overflow-hidden">
        <View className="absolute -top-10 -right-10 w-40 h-40 rounded-full bg-[#FFD9E3] opacity-15" />
        <View className="absolute top-[320px] -left-10 w-36 h-36 rounded-full bg-[#EEE199] opacity-12" />
      </View>

      <ScrollView showsVerticalScrollIndicator={false} showsHorizontalScrollIndicator={false} bounces={false} overScrollMode="never" contentContainerClassName="px-6 pt-14 pb-28" contentContainerStyle={{ flexGrow: 1 }}>
        <View className="w-full max-w-[400px] self-center">
          <Text className="text-[11px] font-bold tracking-[1px] text-[#864D61]" style={{ fontFamily: "Space Mono" }}>
            RUANG KITA • PENGATURAN
          </Text>
          <Text className="mt-1 text-[26px] font-extrabold tracking-[-1px] text-[#1B1C1A]" style={{ fontFamily: "Bricolage Grotesque" }}>
            Pengaturan
          </Text>

          {/* profil couple - paper card signature */}
          <View className="mt-4 bg-white rounded-[20px] border-[1.5px] border-[#1B1C1A] p-4" style={{ shadowColor: C.ink, shadowOpacity: 1, shadowRadius: 0, shadowOffset: { width: 4, height: 4 }, transform: [{ rotate: "-0.3deg" }] }}>
            <View className="absolute -top-2 left-6 z-10">
              <WashiTape w={48} rotate="-3deg" color={C.yellow} />
            </View>
            <View className="flex-row items-center gap-3">
              <View className="flex-row -space-x-3">
                <View className="w-12 h-12 rounded-full bg-[#FFD9E3] border-[1.6px] border-[#1B1C1A] items-center justify-center" style={{ transform: [{ rotate: "-2deg" }] }}>
                  <Text className="text-[14px] font-extrabold text-[#1B1C1A]" style={{ fontFamily: "Bricolage Grotesque" }}>
                    A
                  </Text>
                </View>
                <View className="w-12 h-12 rounded-full bg-[#B4EBFF] border-[1.6px] border-[#1B1C1A] items-center justify-center" style={{ transform: [{ rotate: "2deg" }] }}>
                  <Text className="text-[14px] font-extrabold text-[#1B1C1A]" style={{ fontFamily: "Bricolage Grotesque" }}>
                    B
                  </Text>
                </View>
              </View>
              <View className="flex-1">
                <Text className="text-[15px] font-extrabold text-[#1B1C1A]" style={{ fontFamily: "Bricolage Grotesque" }}>
                  Alya & Bima
                </Text>
                <Text className="text-[11px] text-[#837377]" style={{ fontFamily: "Space Mono" }}>
                  OUR-A1B2 • sejak 14 Apr 2023
                </Text>
              </View>
              <View className="w-8 h-8 rounded-full bg-[#1B1C1A] items-center justify-center">
                <Heart size={14} color="#fff" fill="#FFB7CE" />
              </View>
            </View>

            {/* nama ruang - ruled notebook line (design.md Input Fields) */}
            <View className="mt-4 gap-1.5">
              <Text className="text-[11px] font-bold tracking-[0.7px] text-[#837377]" style={{ fontFamily: "Space Mono" }}>
                NAMA RUANG
              </Text>
              <View className="flex-row items-end gap-2 border-b-[1.6px] border-[#1B1C1A] pb-2">
                <TextInput value={namaRuang} onChangeText={setNamaRuang} className="flex-1 text-[15px] p-0" style={{ fontFamily: "Bricolage Grotesque", paddingVertical: 0, color: C.ink }} />
                <View className="w-6 h-6 rounded-full bg-[#FDFCF8] border border-[#1B1C1A] items-center justify-center">
                  <PenIcon />
                </View>
              </View>
              <Text className="text-[11px] text-[#837377]" style={{ fontFamily: "Space Mono" }}>
                Nama ini tampil di cover jurnal kalian
              </Text>
            </View>

            <View className="mt-3 flex-row gap-2">
              <View className="bg-[#1B1C1A] rounded-full px-2.5 py-1 flex-row items-center gap-1.5">
                <Shield size={11} color="#fff" />
                <Text className="text-[10px] font-bold text-white" style={{ fontFamily: "Space Mono" }}>
                  TERENKRIPSI
                </Text>
              </View>
              <Pressable
                onPress={() => {
                  setCopied(true);
                  setTimeout(() => setCopied(false), 1200);
                }}
                className="bg-white border border-[#1B1C1A] rounded-full px-2.5 py-1 flex-row items-center gap-1.5"
              >
                {copied ? <Check size={11} color={C.ink} /> : <Copy size={11} color={C.ink} />}
                <Text className="text-[10px] font-bold text-[#1B1C1A]" style={{ fontFamily: "Space Mono" }}>
                  {copied ? "TERSALIN" : "SALIN KODE"}
                </Text>
              </Pressable>
            </View>
          </View>

          {/* section: preferensi */}
          <View className="mt-6">
            <View className="flex-row items-center gap-2">
              <Bell size={13} color="#864D61" strokeWidth={2} />
              <Text className="text-[11px] font-bold tracking-[0.8px] text-[#864D61]" style={{ fontFamily: "Space Mono" }}>
                PREFERENSI
              </Text>
              <View className="flex-1 h-[1px] bg-[#D5C2C6] opacity-30" />
            </View>

            <View className="mt-3 bg-white rounded-[16px] border-[1.5px] border-[#1B1C1A] overflow-hidden" style={{ shadowColor: C.ink, shadowOpacity: 1, shadowRadius: 0, shadowOffset: { width: 3, height: 3 } }}>
              <View className="flex-row items-center justify-between p-4 border-b border-black/5">
                <View className="flex-row items-center gap-3 flex-1">
                  <View className="w-9 h-9 rounded-[10px] bg-[#FFD9E3] border border-[#1B1C1A] items-center justify-center">
                    <Heart size={16} color={C.ink} strokeWidth={1.8} />
                  </View>
                  <View className="flex-1">
                    <Text className="text-[14px] font-bold text-[#1B1C1A]" style={{ fontFamily: "Bricolage Grotesque" }}>
                      Pengingat kencan
                    </Text>
                    <Text className="text-[11px] text-[#837377]" style={{ fontFamily: "Space Mono" }}>
                      1 jam sebelum janji
                    </Text>
                  </View>
                </View>
                <DoodleToggle value={notifKencan} onToggle={() => setNotifKencan((v) => !v)} />
              </View>

              <View className="flex-row items-center justify-between p-4">
                <View className="flex-row items-center gap-3 flex-1">
                  <View className="w-9 h-9 rounded-[10px] bg-[#EEE199] border border-[#1B1C1A] items-center justify-center">
                    <Bell size={16} color={C.ink} strokeWidth={1.8} />
                  </View>
                  <View className="flex-1">
                    <Text className="text-[14px] font-bold text-[#1B1C1A]" style={{ fontFamily: "Bricolage Grotesque" }}>
                      Sapa harian
                    </Text>
                    <Text className="text-[11px] text-[#837377]" style={{ fontFamily: "Space Mono" }}>
                      Jam 08:00 tiap pagi
                    </Text>
                  </View>
                </View>
                <DoodleToggle value={notifHarian} onToggle={() => setNotifHarian((v) => !v)} />
              </View>
            </View>

            {/* tema kertas - Dymo chips + paper preview */}
            <View className="mt-4 bg-white rounded-[16px] border-[1.5px] border-[#1B1C1A] p-4" style={{ shadowColor: C.ink, shadowOpacity: 1, shadowRadius: 0, shadowOffset: { width: 3, height: 3 }, transform: [{ rotate: "0.2deg" }] }}>
              <View className="absolute -top-1.5 right-4 z-10">
                <WashiTape w={40} rotate="3deg" color={C.blue} />
              </View>
              <View className="flex-row items-center gap-2">
                <Palette size={14} color={C.ink} strokeWidth={1.8} />
                <Text className="text-[11px] font-bold tracking-[0.7px] text-[#837377]" style={{ fontFamily: "Space Mono" }}>
                  TEMA KERTAS
                </Text>
                <View className="ml-auto bg-[#FDFCF8] border border-[#D5C2C6] rounded-full px-2 py-1">
                  <Text className="text-[10px] font-bold text-[#837377]" style={{ fontFamily: "Space Mono" }}>
                    PRATINJAU LANGSUNG
                  </Text>
                </View>
              </View>
              <View className="flex-row gap-2 mt-3">
                {kertasOpts.map((k) => (
                  <Pressable key={k.id} onPress={() => setKertas(k.id)} className="flex-1 rounded-[12px] border-[1.6px] p-2.5 items-center gap-1.5" style={{ backgroundColor: k.hex, borderColor: kertas === k.id ? C.ink : "#E8D9E0", transform: [{ rotate: kertas === k.id ? "-0.6deg" : "0deg" }] }}>
                    <View className="w-6 h-6 rounded-full border border-[#1B1C1A] bg-white items-center justify-center">
                      {kertas === k.id ? <Check size={12} color={C.ink} strokeWidth={2.5} /> : <View className="w-2 h-2 rounded-full bg-[#1B1C1A] opacity-20" />}
                    </View>
                    <Text className="text-[11px] font-bold text-[#1B1C1A] text-center" style={{ fontFamily: "Space Mono" }}>
                      {k.label}
                    </Text>
                    <Text className="text-[10px] text-[#514347] text-center" style={{ fontFamily: "Space Mono" }}>
                      {k.desc}
                    </Text>
                  </Pressable>
                ))}
              </View>
              <View className="mt-3 h-2 rounded-full bg-[#FDFCF8] border border-[#1B1C1A] overflow-hidden flex-row">
                <View className="flex-1" style={{ backgroundColor: kertasOpts.find((x) => x.id === kertas)?.hex }} />
              </View>
            </View>
          </View>

          {/* section: privasi - hand checkboxes */}
          <View className="mt-6">
            <View className="flex-row items-center gap-2">
              <Lock size={13} color="#864D61" strokeWidth={2} />
              <Text className="text-[11px] font-bold tracking-[0.8px] text-[#864D61]" style={{ fontFamily: "Space Mono" }}>
                PRIVASI & KEAMANAN
              </Text>
              <View className="flex-1 h-[1px] bg-[#D5C2C6] opacity-30" />
            </View>

            <View className="mt-3 gap-2.5">
              <View className="bg-white rounded-[14px] border-[1.4px] border-[#1B1C1A] p-4 flex-row items-center gap-3" style={{ shadowColor: C.ink, shadowOpacity: 0.06, shadowRadius: 0, shadowOffset: { width: 2, height: 2 } }}>
                <HandCheckbox checked={privateMode} onPress={() => setPrivateMode((v) => !v)} />
                <View className="flex-1">
                  <Text className="text-[13px] font-bold text-[#1B1C1A]" style={{ fontFamily: "Bricolage Grotesque" }}>
                    Ruang privat penuh
                  </Text>
                  <Text className="text-[11px] leading-4 text-[#514347]" style={{ fontFamily: "Plus Jakarta Sans" }}>
                    Hanya kalian berdua yang bisa lihat — tanpa algoritma, tanpa iklan.
                  </Text>
                </View>
                <View className="bg-[#C6F0D1] border border-[#1B1C1A] rounded-full px-2 py-1">
                  <Text className="text-[10px] font-bold text-[#1B1C1A]" style={{ fontFamily: "Space Mono" }}>
                    AKTIF
                  </Text>
                </View>
              </View>

              <Pressable className="bg-white rounded-[14px] border-[1.4px] border-[#1B1C1A] p-4 flex-row items-center gap-3 active:opacity-90" style={{ shadowColor: C.ink, shadowOpacity: 1, shadowRadius: 0, shadowOffset: { width: 3, height: 3 } }}>
                <View className="w-9 h-9 rounded-full bg-[#FDFCF8] border border-[#1B1C1A] items-center justify-center">
                  <Shield size={16} color={C.ink} strokeWidth={1.8} />
                </View>
                <View className="flex-1">
                  <Text className="text-[14px] font-bold text-[#1B1C1A]" style={{ fontFamily: "Bricolage Grotesque" }}>
                    Kelola enkripsi
                  </Text>
                  <Text className="text-[11px] text-[#837377]" style={{ fontFamily: "Space Mono" }}>
                    Kunci & cadangan
                  </Text>
                </View>
                <ChevronRight size={16} color="#837377" />
              </Pressable>
            </View>
          </View>

          {/* danger zone - torn edge feel */}
          <View className="mt-6 rounded-[14px] border-[1.4px] border-[#ba1a1a] bg-[#ffdad6] p-4 flex-row items-center gap-3" style={{ transform: [{ rotate: "0.2deg" }] }}>
            <View className="w-9 h-9 rounded-full bg-white border border-[#ba1a1a] items-center justify-center">
              <Trash2 size={16} color={C.error} strokeWidth={1.8} />
            </View>
            <View className="flex-1">
              <Text className="text-[13px] font-bold" style={{ fontFamily: "Bricolage Grotesque", color: "#93000a" }}>
                Hapus ruang
              </Text>
              <Text className="text-[11px]" style={{ fontFamily: "Space Mono", color: "#93000a" }}>
                Hapus permanen — tidak bisa dikembalikan
              </Text>
            </View>
            <Pressable className="bg-white border border-[#ba1a1a] rounded-full px-3 py-1.5">
              <Text className="text-[11px] font-bold" style={{ fontFamily: "Space Mono", color: C.error }}>
                HAPUS
              </Text>
            </Pressable>
          </View>

          <Link href="/" asChild>
            <Pressable className="mt-4 bg-white rounded-full border-[1.4px] border-[#1B1C1A] py-3 flex-row items-center justify-center gap-2 active:opacity-90">
              <LogOut size={16} color={C.ink} />
              <Text className="text-[13px] font-bold text-[#1B1C1A]" style={{ fontFamily: "Space Mono" }}>
                Keluar
              </Text>
            </Pressable>
          </Link>

          <View className="flex-row items-center justify-center gap-1 mt-3">
            <Text className="text-[10px] text-[#837377]" style={{ fontFamily: "Space Mono" }}>
              v1.0 • dibuat dengan
            </Text>
            <Heart size={10} color="#864D61" fill="#FFB7CE" strokeWidth={1.6} />
            <Text className="text-[10px] text-[#837377]" style={{ fontFamily: "Space Mono" }}>
              di OurSpace
            </Text>
          </View>
        </View>
      </ScrollView>
    </View>
  );
}

function PenIcon() {
  return (
    <View style={{ transform: [{ rotate: "-12deg" }] }}>
      <PenLine size={12} color="#1B1C1A" strokeWidth={1.8} />
    </View>
  );
}
