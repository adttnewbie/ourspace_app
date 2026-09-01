import { View, Text, ScrollView } from "react-native";
import { Images, Heart, Search } from "lucide-react-native";
import { WashiTape } from "@/components/ui/washi-tape";

const C = { ink: "#1B1C1A", yellow: "#EEE199", blue: "#B4EBFF", pink: "#FFB7CE" };

const TILES = [
  { id: 1, date: "28 AUG", title: "Pantai jam 5 sore", color: "#FFD9E3", rot: "-0.8deg" },
  { id: 2, date: "22 AUG", title: "Masak bareng — gagal tapi enak", color: "#EEE199", rot: "0.7deg" },
  { id: 3, date: "15 AUG", title: "Nonton hujan dari jendela", color: "#B4EBFF", rot: "-0.5deg" },
];

export default function MemoriesTab() {
  return (
    <View className="flex-1 bg-[#FDFCF8]">
      <ScrollView showsVerticalScrollIndicator={false} contentContainerClassName="px-6 pt-14 pb-28" bounces={false}>
        <View className="w-full max-w-[400px] self-center">
          <Text className="text-[11px] font-bold tracking-[1px] text-[#837377]" style={{ fontFamily: "Space Mono" }}>
            KOLEKSI • 12 KENANGAN
          </Text>
          <Text className="text-[28px] font-extrabold tracking-[-1px] text-[#1B1C1A] mt-1" style={{ fontFamily: "Bricolage Grotesque" }}>
            Kenangan
          </Text>
          <View className="mt-3 flex-row items-center gap-2 bg-white border border-[#1B1C1A] rounded-full px-3 py-2.5" style={{ shadowColor: C.ink, shadowOpacity: 1, shadowRadius: 0, shadowOffset: { width: 3, height: 3 } }}>
            <Search size={16} color="#837377" />
            <Text className="text-[13px] text-[#837377]" style={{ fontFamily: "Space Mono" }}>
              Cari foto, catatan...
            </Text>
          </View>

          <View className="mt-6 gap-4">
            {TILES.map((t) => (
              <View key={t.id} className="bg-white rounded-[16px] border-[1.5px] border-[#1B1C1A] p-3" style={{ shadowColor: C.ink, shadowOpacity: 1, shadowRadius: 0, shadowOffset: { width: 4, height: 4 }, transform: [{ rotate: t.rot }] }}>
                <View className="absolute -top-2 left-5 z-10">
                  <WashiTape w={42} rotate="-3deg" color={t.color} />
                </View>
                <View className="h-[140px] rounded-xl border border-black/5 items-center justify-center" style={{ backgroundColor: t.color }}>
                  <Images size={28} color={C.ink} strokeWidth={1.6} />
                  <Text className="text-[10px] font-bold tracking-[1px] text-[#1B1C1A] mt-1" style={{ fontFamily: "Space Mono" }}>
                    {t.date}
                  </Text>
                </View>
                <Text className="mt-2.5 text-[15px] font-bold text-[#1B1C1A]" style={{ fontFamily: "Bricolage Grotesque" }}>
                  {t.title}
                </Text>
                <View className="mt-1.5 flex-row gap-1.5">
                  <View className="bg-[#1B1C1A] rounded-full px-2 py-1">
                    <Text className="text-[10px] font-bold text-white" style={{ fontFamily: "Space Mono" }}>
                      FOTO
                    </Text>
                  </View>
                  <Heart size={14} color="#864D61" fill="#FFB7CE" />
                </View>
              </View>
            ))}
          </View>
        </View>
      </ScrollView>
    </View>
  );
}
