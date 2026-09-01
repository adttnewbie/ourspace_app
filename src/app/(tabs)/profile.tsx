import { View, Text, Pressable, ScrollView } from "react-native";
import { Link } from "expo-router";
import { User, Heart, LogOut, Shield, Settings } from "lucide-react-native";
import { WashiTape } from "@/components/ui/washi-tape";

const C = { ink: "#1B1C1A", pink: "#FFB7CE", yellow: "#EEE199" };

export default function ProfileTab() {
  return (
    <View className="flex-1 bg-[#FDFCF8]">
      <ScrollView showsVerticalScrollIndicator={false} contentContainerClassName="px-6 pt-14 pb-28" bounces={false}>
        <View className="w-full max-w-[400px] self-center">
          <View className="bg-white rounded-[20px] border-[1.5px] border-[#1B1C1A] p-5 items-center" style={{ shadowColor: C.ink, shadowOpacity: 1, shadowRadius: 0, shadowOffset: { width: 4, height: 4 }, transform: [{ rotate: "-0.4deg" }] }}>
            <View className="absolute -top-2 left-7 z-10">
              <WashiTape w={52} rotate="-3deg" color={C.yellow} />
            </View>
            <View className="w-16 h-16 rounded-full bg-[#FFD9E3] border-[1.6px] border-[#1B1C1A] items-center justify-center">
              <User size={26} color={C.ink} strokeWidth={1.8} />
            </View>
            <Text className="mt-3 text-[18px] font-extrabold text-[#1B1C1A]" style={{ fontFamily: "Bricolage Grotesque" }}>
              Alya & Bima
            </Text>
            <Text className="text-[12px] text-[#837377]" style={{ fontFamily: "Space Mono" }}>
              OUR-A1B2 • sejak 14 Apr 2025
            </Text>
            <View className="mt-3 flex-row gap-2">
              <View className="bg-[#1B1C1A] rounded-full px-3 py-1.5 flex-row items-center gap-1.5">
                <Shield size={12} color="#fff" />
                <Text className="text-[11px] font-bold text-white" style={{ fontFamily: "Space Mono" }}>
                  TERENKRIPSI
                </Text>
              </View>
              <View className="bg-[#EEE199] rounded-full px-3 py-1.5 border border-[#1B1C1A]">
                <Text className="text-[11px] font-bold text-[#1B1C1A]" style={{ fontFamily: "Space Mono" }}>
                  PRIVAT
                </Text>
              </View>
            </View>
          </View>

          <View className="mt-5 gap-2.5">
            {[
              { Icon: Settings, label: "Pengaturan ruang", sub: "Notifikasi, tema kertas" },
              { Icon: Heart, label: "Undang pasangan", sub: "Bagikan kode OUR-A1B2" },
            ].map((it) => (
              <View key={it.label} className="bg-white rounded-[14px] border-[1.4px] border-[#1B1C1A] p-4 flex-row items-center gap-3" style={{ shadowColor: C.ink, shadowOpacity: 1, shadowRadius: 0, shadowOffset: { width: 3, height: 3 } }}>
                <View className="w-9 h-9 rounded-full bg-[#FDFCF8] border border-[#1B1C1A] items-center justify-center">
                  <it.Icon size={16} color={C.ink} strokeWidth={1.8} />
                </View>
                <View className="flex-1">
                  <Text className="text-[14px] font-bold text-[#1B1C1A]" style={{ fontFamily: "Bricolage Grotesque" }}>
                    {it.label}
                  </Text>
                  <Text className="text-[12px] text-[#837377]" style={{ fontFamily: "Space Mono" }}>
                    {it.sub}
                  </Text>
                </View>
              </View>
            ))}

            <Link href="/" asChild>
              <Pressable className="mt-2 bg-white rounded-full border-[1.4px] border-[#ba1a1a] py-3 flex-row items-center justify-center gap-2">
                <LogOut size={16} color="#ba1a1a" />
                <Text className="text-[13px] font-bold text-[#ba1a1a]" style={{ fontFamily: "Space Mono" }}>
                  Keluar
                </Text>
              </Pressable>
            </Link>
            <Text className="text-center text-[10px] text-[#837377] mt-1" style={{ fontFamily: "Space Mono" }}>
              v1.0 • dibuat dengan ♡ di OurSpace
            </Text>
          </View>
        </View>
      </ScrollView>
    </View>
  );
}
