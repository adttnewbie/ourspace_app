import { View, Text, ScrollView } from "react-native";
import { Heart, CalendarHeart, Images, Clock3, MapPin, Sparkles } from "lucide-react-native";
import { WashiTape } from "@/components/ui/washi-tape";

const C = { ink: "#1B1C1A", pink: "#FFB7CE", pinkSoft: "#FFD9E3", yellow: "#EEE199", blue: "#B4EBFF", muted: "#514347", outline: "#837377" };

// helper hitung durasi dari 14 Apr 2023
function getDuration() {
  const start = new Date(2023, 3, 14);
  const now = new Date();
  const diff = now.getTime() - start.getTime();
  const days = Math.floor(diff / 86400000);
  const years = Math.floor(days / 365);
  const months = Math.floor((days % 365) / 30);
  return { days, years, months, startLabel: "14 Apr 2023" };
}

export default function HomeTab() {
  const { days, years, months, startLabel } = getDuration();
  const yearLabel = years > 0 ? `${years} tahun${months ? ` ${months} bulan` : ""}` : `${months} bulan`;

  return (
    <View className="flex-1 bg-[#FDFCF8] overflow-hidden">
      <View pointerEvents="none" className="absolute inset-0 overflow-hidden">
        <View className="absolute -top-10 -right-10 w-48 h-48 rounded-full bg-[#FFD9E3] opacity-20" />
        <View className="absolute top-[260px] -left-10 w-40 h-40 rounded-full bg-[#B4EBFF] opacity-15" />
        <View className="absolute bottom-32 right-2 w-28 h-28 rounded-full bg-[#EEE199] opacity-15" />
      </View>

      <ScrollView
        showsVerticalScrollIndicator={false}
        showsHorizontalScrollIndicator={false}
        bounces={false}
        overScrollMode="never"
        contentContainerClassName="px-6 pt-14 pb-28"
        contentContainerStyle={{ flexGrow: 1 }}
      >
        <View className="w-full max-w-[400px] self-center">
          {/* top bar */}
          <View className="flex-row items-center justify-between">
            <View className="flex-row items-center gap-2">
              <View className="w-2 h-2 rounded-full bg-[#864D61]" />
              <Text className="text-[11px] font-bold tracking-[1.2px] text-[#837377]" style={{ fontFamily: "Space Mono" }}>
                RUANG KITA
              </Text>
              <View className="px-2 py-1 rounded-full bg-white border border-[#D5C2C6]">
                <Text className="text-[10px] font-bold text-[#514347]" style={{ fontFamily: "Space Mono" }}>
                  OUR-A1B2
                </Text>
              </View>
            </View>
            <View className="w-9 h-9 rounded-full bg-white border border-[#1B1C1A] items-center justify-center" style={{ shadowColor: C.ink, shadowOpacity: 1, shadowRadius: 0, shadowOffset: { width: 2, height: 2 } }}>
              <Heart size={14} color={C.ink} fill={C.pink} strokeWidth={1.6} />
            </View>
          </View>

          {/* hero - nama couple thesis - single source for identity */}
          <View className="mt-6">
            <Text className="text-[11px] font-bold tracking-[1.2px] text-[#864D61]" style={{ fontFamily: "Space Mono" }}>
              RUANG PRIBADI • UNTUK BERDUA
            </Text>
            <Text className="mt-1.5 text-[34px] font-extrabold leading-[36px] tracking-[-1.2px] text-[#1B1C1A]" style={{ fontFamily: "Bricolage Grotesque" }}>
              Alya <Text className="font-light text-[#837377]">&</Text> Bima
            </Text>
            <View className="mt-2 self-start bg-[#1B1C1A] rounded-full px-3 py-1.5">
              <Text className="text-[12px] font-bold text-white tracking-[0.3px]" style={{ fontFamily: "Space Mono" }}>
                {yearLabel}
              </Text>
            </View>
          </View>

          {/* main couple card - signature */}
          <View className="mt-5 bg-white rounded-[20px] border-[1.5px] border-[#1B1C1A] p-4 pt-5" style={{ shadowColor: C.ink, shadowOpacity: 1, shadowRadius: 0, shadowOffset: { width: 4, height: 4 }, transform: [{ rotate: "-0.3deg" }] }}>
            <View className="absolute -top-2 left-6 z-10">
              <WashiTape w={52} rotate="-3deg" color={C.yellow} />
            </View>
            <View className="absolute -top-2 right-7 z-10">
              <WashiTape w={44} rotate="3deg" color={C.blue} />
            </View>

            {/* avatars overlapping - initials only, full name single source below */}
            <View className="flex-row items-center justify-center gap-0">
              <View className="w-[86px] h-[86px] rounded-full bg-[#FFD9E3] border-[1.6px] border-[#1B1C1A] items-center justify-center" style={{ transform: [{ rotate: "-2deg" }] }}>
                <Text className="text-[32px] font-extrabold text-[#1B1C1A]" style={{ fontFamily: "Bricolage Grotesque" }}>
                  A
                </Text>
                <View className="absolute -bottom-1 -right-1 w-6 h-6 rounded-full bg-white border border-[#1B1C1A] items-center justify-center">
                  <Sparkles size={12} color={C.ink} strokeWidth={2} />
                </View>
              </View>

              <View className="w-10 h-10 rounded-full bg-[#F1E39C] border-[1.5px] border-[#1B1C1A] items-center justify-center z-10 -mx-3" style={{ transform: [{ rotate: "8deg" }] }}>
                <Heart size={16} color={C.ink} fill="#864D61" strokeWidth={1.6} />
              </View>

              <View className="w-[86px] h-[86px] rounded-full bg-[#B4EBFF] border-[1.6px] border-[#1B1C1A] items-center justify-center" style={{ transform: [{ rotate: "2deg" }] }}>
                <Text className="text-[32px] font-extrabold text-[#1B1C1A]" style={{ fontFamily: "Bricolage Grotesque" }}>
                  B
                </Text>
                <View className="absolute -bottom-1 -left-1 w-6 h-6 rounded-full bg-white border border-[#1B1C1A] items-center justify-center">
                  <Heart size={12} color={C.ink} fill={C.blue} strokeWidth={1.6} />
                </View>
              </View>
            </View>

            {/* names row */}
            <View className="mt-3 flex-row justify-center gap-6">
              <Text className="text-[14px] font-bold text-[#1B1C1A]" style={{ fontFamily: "Bricolage Grotesque" }}>
                Alya Putri
              </Text>
              <Text className="text-[#D5C2C6]">•</Text>
              <Text className="text-[14px] font-bold text-[#1B1C1A]" style={{ fontFamily: "Bricolage Grotesque" }}>
                Bima Saputra
              </Text>
            </View>
            <Text className="text-center text-[11px] tracking-[0.4px] text-[#837377] mt-0.5" style={{ fontFamily: "Space Mono" }}>
              @alya • @bima • Jakarta • sejak {startLabel}
            </Text>

            {/* divider hand-drawn */}
            <View className="mt-4 flex-row items-center gap-2">
              <View className="flex-1 h-[1px] bg-[#1B1C1A] opacity-10" />
              <Text className="text-[10px] tracking-[0.6px] text-[#837377]" style={{ fontFamily: "Space Mono" }}>
                ✦ CERITA KITA ✦
              </Text>
              <View className="flex-1 h-[1px] bg-[#1B1C1A] opacity-10" />
            </View>

            {/* stats inside card */}
            <View className="mt-3 flex-row gap-2">
              <View className="flex-1 bg-[#FDFCF8] rounded-[12px] border border-black/5 p-3 items-center">
                <Clock3 size={16} color={C.ink} strokeWidth={1.8} />
                <Text className="mt-1 text-[16px] font-extrabold text-[#1B1C1A]" style={{ fontFamily: "Bricolage Grotesque" }}>
                  {days}
                </Text>
                <Text className="text-[10px] font-bold tracking-[0.6px] text-[#837377]" style={{ fontFamily: "Space Mono" }}>
                  HARI BERSAMA
                </Text>
              </View>
              <View className="flex-1 bg-[#FDFCF8] rounded-[12px] border border-black/5 p-3 items-center">
                <Images size={16} color={C.ink} strokeWidth={1.8} />
                <Text className="mt-1 text-[16px] font-extrabold text-[#1B1C1A]" style={{ fontFamily: "Bricolage Grotesque" }}>
                  48
                </Text>
                <Text className="text-[10px] font-bold tracking-[0.6px] text-[#837377]" style={{ fontFamily: "Space Mono" }}>
                  KENANGAN
                </Text>
              </View>
              <View className="flex-1 bg-[#FDFCF8] rounded-[12px] border border-black/5 p-3 items-center">
                <MapPin size={16} color={C.ink} strokeWidth={1.8} />
                <Text className="mt-1 text-[16px] font-extrabold text-[#1B1C1A]" style={{ fontFamily: "Bricolage Grotesque" }}>
                  12
                </Text>
                <Text className="text-[10px] font-bold tracking-[0.6px] text-[#837377]" style={{ fontFamily: "Space Mono" }}>
                  TEMPAT
                </Text>
              </View>
            </View>

            {/* next anniversary pencil bar */}
            <View className="mt-4 bg-[#EEE199] rounded-full border border-[#1B1C1A] px-3 py-2.5 flex-row items-center gap-2.5">
              <View className="w-8 h-8 rounded-full bg-white border border-[#1B1C1A] items-center justify-center">
                <CalendarHeart size={14} color={C.ink} strokeWidth={2} />
              </View>
              <View className="flex-1">
                <Text className="text-[12px] font-bold text-[#1B1C1A]" style={{ fontFamily: "Space Mono" }}>
                  14 Oktober • 3 tahun! 🎉
                </Text>
                <View className="mt-1 h-2 rounded-full bg-white border border-[#1B1C1A] overflow-hidden">
                  <View className="h-full bg-[#864D61] rounded-full" style={{ width: "82%" }} />
                </View>
              </View>
              <Text className="text-[11px] font-bold text-[#1B1C1A]" style={{ fontFamily: "Space Mono" }}>
                18hr
              </Text>
            </View>
          </View>

          {/* quick chips - only info not yet shown elsewhere */}
          <View className="mt-4 flex-row flex-wrap gap-2">
            <View className="bg-white border border-[#D5C2C6] rounded-full px-3 py-1.5">
              <Text className="text-[11px] font-bold text-[#514347]" style={{ fontFamily: "Space Mono" }}>
                Streak 12 hari 🔥
              </Text>
            </View>
            <View className="bg-[#B4EBFF] border border-[#1B1C1A] rounded-full px-3 py-1.5">
              <Text className="text-[11px] font-bold text-[#1B1C1A]" style={{ fontFamily: "Space Mono" }}>
                Lagu kita: Rumah
              </Text>
            </View>
          </View>

          <View className="mt-5 flex-row items-center gap-2">
            <View className="flex-1 h-[1px] bg-[#D5C2C6] opacity-30" />
            <Text className="text-[11px] italic text-[#837377]" style={{ fontFamily: "Bricolage Grotesque" }}>
              one day at a time
            </Text>
            <Heart size={10} color="#864D61" fill="#FFB7CE" />
            <View className="flex-1 h-[1px] bg-[#D5C2C6] opacity-30" />
          </View>
        </View>
      </ScrollView>
    </View>
  );
}
