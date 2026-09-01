import { WashiTape } from "@/components/ui/washi-tape";
import {
  CalendarHeart,
  ChevronRight,
  Clock3,
  Heart,
  Images,
  MapPin,
  Sparkles,
  PenLine,
  Camera,
  StickyNote,
} from "lucide-react-native";
import { Link } from "expo-router";
import { useEffect, useState } from "react";
import { Pressable, ScrollView, Text, View } from "react-native";

const C = {
  ink: "#1B1C1A",
  pink: "#FFB7CE",
  pinkSoft: "#FFD9E3",
  yellow: "#EEE199",
  blue: "#B4EBFF",
  muted: "#514347",
  outline: "#837377",
};

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
  const [duration, setDuration] = useState(() => getDuration());
  // hindari hydration mismatch: hitung ulang setelah mount
  useEffect(() => { setDuration(getDuration()); }, []);
  const { days, years, months, startLabel } = duration;
  const yearLabel =
    years > 0
      ? `${years} tahun${months ? ` ${months} bulan` : ""}`
      : `${months} bulan`;

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
              <Text
                className="text-[11px] font-bold tracking-[1.2px] text-[#837377]"
                style={{ fontFamily: "Space Mono" }}
              >
                RUANG KITA
              </Text>
              <View className="px-2 py-1 rounded-full bg-white border border-[#D5C2C6]">
                <Text
                  className="text-[10px] font-bold text-[#514347]"
                  style={{ fontFamily: "Space Mono" }}
                >
                  OUR-A1B2
                </Text>
              </View>
            </View>
            <View
              className="w-9 h-9 rounded-full bg-white border border-[#1B1C1A] items-center justify-center"
              style={{
                shadowColor: C.ink,
                shadowOpacity: 1,
                shadowRadius: 0,
                shadowOffset: { width: 2, height: 2 },
              }}
            >
              <Heart size={14} color={C.ink} fill={C.pink} strokeWidth={1.6} />
            </View>
          </View>

          {/* hero - nama couple thesis - single source for identity */}
          <View className="mt-6">
            <Text
              className="text-[11px] font-bold tracking-[1.2px] text-[#864D61]"
              style={{ fontFamily: "Space Mono" }}
            >
              RUANG PRIBADI • UNTUK BERDUA
            </Text>
            <Text
              className="mt-1.5 text-[34px] font-extrabold leading-[36px] tracking-[-1.2px] text-[#1B1C1A]"
              style={{ fontFamily: "Bricolage Grotesque" }}
            >
              Alya <Text className="font-light text-[#837377]">&</Text> Bima
            </Text>
            <View className="mt-2 self-start bg-[#1B1C1A] rounded-full px-3 py-1.5">
              <Text
                className="text-[12px] font-bold text-white tracking-[0.3px]"
                style={{ fontFamily: "Space Mono" }}
              >
                {yearLabel}
              </Text>
            </View>
          </View>

          {/* main couple card - signature - overflow-visible agar washi tape tidak ter-clip di Android */}
          <View
            className="mt-5 bg-white rounded-[20px] border-[1.5px] border-[#1B1C1A] p-4 pt-5 overflow-visible"
            style={{
              shadowColor: C.ink,
              shadowOpacity: 1,
              shadowRadius: 0,
              shadowOffset: { width: 4, height: 4 },
              transform: [{ rotate: "-0.3deg" }],
              overflow: "visible",
            }}
          >
            <View className="absolute -top-2 left-6 z-10">
              <WashiTape w={52} rotate="-3deg" color={C.yellow} />
            </View>
            <View className="absolute -top-2 right-7 z-10">
              <WashiTape w={44} rotate="3deg" color={C.blue} />
            </View>

            {/* avatars overlapping - initials only, full name single source below */}
            <View className="flex-row items-center justify-center gap-0">
              <View
                className="w-[86px] h-[86px] rounded-full bg-[#FFD9E3] border-[1.6px] border-[#1B1C1A] items-center justify-center"
                style={{ transform: [{ rotate: "-2deg" }] }}
              >
                <Text
                  className="text-[32px] font-extrabold text-[#1B1C1A]"
                  style={{ fontFamily: "Bricolage Grotesque" }}
                >
                  A
                </Text>
                <View className="absolute -bottom-1 -right-1 w-6 h-6 rounded-full bg-white border border-[#1B1C1A] items-center justify-center">
                  <Sparkles size={12} color={C.ink} strokeWidth={2} />
                </View>
              </View>

              <View
                className="w-10 h-10 rounded-full bg-[#F1E39C] border-[1.5px] border-[#1B1C1A] items-center justify-center z-10 -mx-3"
                style={{ transform: [{ rotate: "8deg" }] }}
              >
                <Heart
                  size={16}
                  color={C.ink}
                  fill="#864D61"
                  strokeWidth={1.6}
                />
              </View>

              <View
                className="w-[86px] h-[86px] rounded-full bg-[#B4EBFF] border-[1.6px] border-[#1B1C1A] items-center justify-center"
                style={{ transform: [{ rotate: "2deg" }] }}
              >
                <Text
                  className="text-[32px] font-extrabold text-[#1B1C1A]"
                  style={{ fontFamily: "Bricolage Grotesque" }}
                >
                  B
                </Text>
                <View className="absolute -bottom-1 -left-1 w-6 h-6 rounded-full bg-white border border-[#1B1C1A] items-center justify-center">
                  <Heart
                    size={12}
                    color={C.ink}
                    fill={C.blue}
                    strokeWidth={1.6}
                  />
                </View>
              </View>
            </View>

            {/* names row */}
            <View className="mt-3 flex-row justify-center gap-6">
              <Text
                className="text-[14px] font-bold text-[#1B1C1A]"
                style={{ fontFamily: "Bricolage Grotesque" }}
              >
                Alya Putri
              </Text>
              <Text className="text-[#D5C2C6]">•</Text>
              <Text
                className="text-[14px] font-bold text-[#1B1C1A]"
                style={{ fontFamily: "Bricolage Grotesque" }}
              >
                Bima Saputra
              </Text>
            </View>
            <Text
              className="text-center text-[11px] tracking-[0.4px] text-[#837377] mt-0.5"
              style={{ fontFamily: "Space Mono" }}
            >
              @alya • @bima • Jakarta • sejak {startLabel}
            </Text>

            {/* divider hand-drawn */}
            <View className="mt-4 flex-row items-center gap-2">
              <View className="flex-1 h-[1px] bg-[#1B1C1A] opacity-10" />
              <View className="flex-row items-center gap-1.5">
                <Sparkles size={10} color="#837377" strokeWidth={1.8} />
                <Text className="text-[10px] tracking-[0.6px] text-[#837377]" style={{ fontFamily: "Space Mono" }}>
                  CERITA KITA
                </Text>
                <Sparkles size={10} color="#837377" strokeWidth={1.8} />
              </View>
              <View className="flex-1 h-[1px] bg-[#1B1C1A] opacity-10" />
            </View>

            {/* stats inside card */}
            <View className="mt-3 flex-row gap-2">
              <View className="flex-1 bg-[#FDFCF8] rounded-[12px] border border-black/5 p-3 items-center">
                <Clock3 size={16} color={C.ink} strokeWidth={1.8} />
                <Text
                  className="mt-1 text-[16px] font-extrabold text-[#1B1C1A]"
                  style={{ fontFamily: "Bricolage Grotesque" }}
                >
                  {days}
                </Text>
                <Text
                  className="text-[10px] font-bold tracking-[0.6px] text-[#837377]"
                  style={{ fontFamily: "Space Mono" }}
                >
                  HARI BERSAMA
                </Text>
              </View>
              <View className="flex-1 bg-[#FDFCF8] rounded-[12px] border border-black/5 p-3 items-center">
                <Images size={16} color={C.ink} strokeWidth={1.8} />
                <Text
                  className="mt-1 text-[16px] font-extrabold text-[#1B1C1A]"
                  style={{ fontFamily: "Bricolage Grotesque" }}
                >
                  48
                </Text>
                <Text
                  className="text-[10px] font-bold tracking-[0.6px] text-[#837377]"
                  style={{ fontFamily: "Space Mono" }}
                >
                  KENANGAN
                </Text>
              </View>
              <View className="flex-1 bg-[#FDFCF8] rounded-[12px] border border-black/5 p-3 items-center">
                <MapPin size={16} color={C.ink} strokeWidth={1.8} />
                <Text
                  className="mt-1 text-[16px] font-extrabold text-[#1B1C1A]"
                  style={{ fontFamily: "Bricolage Grotesque" }}
                >
                  12
                </Text>
                <Text
                  className="text-[10px] font-bold tracking-[0.6px] text-[#837377]"
                  style={{ fontFamily: "Space Mono" }}
                >
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
                <View className="flex-row items-center gap-1.5">
                  <Text className="text-[12px] font-bold text-[#1B1C1A]" style={{ fontFamily: "Space Mono" }}>
                    14 Oktober • 3 tahun!
                  </Text>
                  <Sparkles size={12} color="#864D61" strokeWidth={2} />
                </View>
                <View className="mt-1 h-2 rounded-full bg-white border border-[#1B1C1A] overflow-hidden">
                  <View
                    className="h-full bg-[#864D61] rounded-full"
                    style={{ width: "82%" }}
                  />
                </View>
              </View>
              <Text
                className="text-[11px] font-bold text-[#1B1C1A]"
                style={{ fontFamily: "Space Mono" }}
              >
                18hr
              </Text>
            </View>
          </View>

          {/* ── elements below card — overview hub, no duplication ── */}
          {/* aksi cepat - shortcut ke 3 tab lain, bukan duplikat list */}
          <View className="mt-5 flex-row gap-2.5">
            <Link href="/(tabs)/notes" asChild>
              <Pressable className="flex-1 bg-white rounded-[14px] border-[1.5px] border-[#1B1C1A] border-dashed py-3 items-center gap-1.5 active:opacity-90" style={{ shadowColor: C.ink, shadowOpacity: 0.06, shadowRadius: 0, shadowOffset: { width: 2, height: 2 } }}>
                <View className="w-8 h-8 rounded-full bg-[#C6F0D1] border border-[#1B1C1A] items-center justify-center">
                  <StickyNote size={16} color={C.ink} strokeWidth={1.8} />
                </View>
                <Text className="text-[11px] font-bold text-center leading-[12px] text-[#1B1C1A]" style={{ fontFamily: "Space Mono" }}>
                  Tulis{"\n"}Catatan
                </Text>
              </Pressable>
            </Link>
            <Link href="/(tabs)/memories" asChild>
              <Pressable className="flex-1 bg-white rounded-[14px] border-[1.5px] border-[#1B1C1A] border-dashed py-3 items-center gap-1.5 active:opacity-90" style={{ shadowColor: C.ink, shadowOpacity: 0.06, shadowRadius: 0, shadowOffset: { width: 2, height: 2 } }}>
                <View className="w-8 h-8 rounded-full bg-[#FFD9E3] border border-[#1B1C1A] items-center justify-center">
                  <Camera size={16} color={C.ink} strokeWidth={1.8} />
                </View>
                <Text className="text-[11px] font-bold text-center leading-[12px] text-[#1B1C1A]" style={{ fontFamily: "Space Mono" }}>
                  Tambah{"\n"}Foto
                </Text>
              </Pressable>
            </Link>
            <Link href="/(tabs)/timeline" asChild>
              <Pressable className="flex-1 bg-white rounded-[14px] border-[1.5px] border-[#1B1C1A] border-dashed py-3 items-center gap-1.5 active:opacity-90" style={{ shadowColor: C.ink, shadowOpacity: 0.06, shadowRadius: 0, shadowOffset: { width: 2, height: 2 } }}>
                <View className="w-8 h-8 rounded-full bg-[#B4EBFF] border border-[#1B1C1A] items-center justify-center">
                  <CalendarHeart size={16} color={C.ink} strokeWidth={1.8} />
                </View>
                <Text className="text-[11px] font-bold text-center leading-[12px] text-[#1B1C1A]" style={{ fontFamily: "Space Mono" }}>
                  Lihat{"\n"}Jejak
                </Text>
              </Pressable>
            </Link>
          </View>

          {/* kenangan terakhir - dynamic stack memory tiles */}
          <View className="mt-5">
            <View className="flex-row items-center justify-between">
              <View className="flex-row items-center gap-2">
                <View className="w-1.5 h-1.5 rounded-full bg-[#864D61]" />
                <Text className="text-[11px] font-bold tracking-[0.8px] text-[#864D61]" style={{ fontFamily: "Space Mono" }}>
                  KENANGAN TERAKHIR
                </Text>
                <View className="bg-[#1B1C1A] rounded-full px-1.5 py-0.5">
                  <Text className="text-[10px] font-bold text-white" style={{ fontFamily: "Space Mono" }}>
                    2
                  </Text>
                </View>
              </View>
              <Link href="/(tabs)/memories" asChild>
                <Pressable className="flex-row items-center gap-1">
                  <Text className="text-[11px] font-bold text-[#837377] underline" style={{ fontFamily: "Space Mono" }}>
                    Lihat semua
                  </Text>
                  <ChevronRight size={12} color="#837377" strokeWidth={2} />
                </Pressable>
              </Link>
            </View>

            <View className="mt-3 flex-row gap-3" style={{ marginBottom: 4 }}>
              {/* tile 1 - pink */}
              <View
                className="flex-1 bg-white rounded-[16px] border-[1.5px] border-[#1B1C1A] p-2.5 overflow-visible"
                style={{ shadowColor: C.ink, shadowOpacity: 1, shadowRadius: 0, shadowOffset: { width: 3, height: 3 }, transform: [{ rotate: "-0.8deg" }], overflow: "visible" as any }}
              >
                <View className="absolute -top-1.5 left-3 z-10">
                  <WashiTape w={36} rotate="-4deg" color={C.pink} />
                </View>
                <View className="h-[96px] rounded-[12px] border border-black/5 bg-[#FFD9E3] items-center justify-center gap-1">
                  <Images size={22} color={C.ink} strokeWidth={1.6} />
                  <Text className="text-[10px] font-bold tracking-[0.6px] text-[#1B1C1A]" style={{ fontFamily: "Space Mono" }}>
                    28 AUG • PANTAI
                  </Text>
                </View>
                <Text className="mt-2 text-[13px] font-bold leading-[16px] text-[#1B1C1A]" style={{ fontFamily: "Bricolage Grotesque" }}>
                  Sore di pantai jam 5
                </Text>
                <Text className="text-[11px] text-[#837377]" style={{ fontFamily: "Space Mono" }}>
                  4 foto • Alya
                </Text>
              </View>

              {/* tile 2 - yellow, overlap via negative margin */}
              <View
                className="flex-1 bg-white rounded-[16px] border-[1.5px] border-[#1B1C1A] p-2.5 overflow-visible"
                style={{ shadowColor: C.ink, shadowOpacity: 1, shadowRadius: 0, shadowOffset: { width: 3, height: 3 }, transform: [{ rotate: "0.7deg" }], marginTop: 8, overflow: "visible" as any }}
              >
                <View className="absolute -top-1.5 right-3 z-10">
                  <WashiTape w={36} rotate="3deg" color={C.yellow} />
                </View>
                <View className="h-[96px] rounded-[12px] border border-black/5 bg-[#EEE199] items-center justify-center gap-1">
                  <PenLine size={22} color={C.ink} strokeWidth={1.6} />
                  <Text className="text-[10px] font-bold tracking-[0.6px] text-[#1B1C1A]" style={{ fontFamily: "Space Mono" }}>
                    22 AUG • SURAT
                  </Text>
                </View>
                <Text className="mt-2 text-[13px] font-bold leading-[16px] text-[#1B1C1A]" style={{ fontFamily: "Bricolage Grotesque" }}>
                  Masak bareng — gagal enak
                </Text>
                <Text className="text-[11px] text-[#837377]" style={{ fontFamily: "Space Mono" }}>
                  surat • Bima
                </Text>
              </View>
            </View>
          </View>

          {/* catatan terbaru - teaser ke tab Notes, bukan duplikat full list */}
          <View className="mt-5">
            <View className="flex-row items-center justify-between">
              <View className="flex-row items-center gap-2">
                <View className="w-1.5 h-1.5 rounded-full bg-[#2E7D5B]" />
                <Text className="text-[11px] font-bold tracking-[0.8px] text-[#2E7D5B]" style={{ fontFamily: "Space Mono" }}>
                  CATATAN TERBARU
                </Text>
              </View>
              <Link href="/(tabs)/notes" asChild>
                <Pressable className="flex-row items-center gap-1">
                  <Text className="text-[11px] font-bold text-[#837377] underline" style={{ fontFamily: "Space Mono" }}>
                    Buka catatan
                  </Text>
                  <ChevronRight size={12} color="#837377" strokeWidth={2} />
                </Pressable>
              </Link>
            </View>
            <Link href="/(tabs)/notes" asChild>
              <Pressable className="mt-2.5 bg-white rounded-[16px] border-[1.5px] border-[#1B1C1A] p-3 flex-row gap-3" style={{ shadowColor: C.ink, shadowOpacity: 1, shadowRadius: 0, shadowOffset: { width: 3, height: 3 }, transform: [{ rotate: "0.4deg" }] }}>
                <View className="w-10 h-10 rounded-[10px] bg-[#C6F0D1] border border-[#1B1C1A] items-center justify-center mt-0.5">
                  <StickyNote size={18} color={C.ink} strokeWidth={1.8} />
                </View>
                <View className="flex-1">
                  <Text className="text-[13px] font-bold leading-[16px] text-[#1B1C1A]" style={{ fontFamily: "Bricolage Grotesque" }}>
                    Surat untukmu — kalau kangen
                  </Text>
                  <Text className="text-[11px] text-[#837377]" style={{ fontFamily: "Space Mono" }}>
                    30 AUG • Alya • 2 balasan
                  </Text>
                  <Text className="mt-1 text-[12px] leading-[16px] text-[#514347]" style={{ fontFamily: "Plus Jakarta Sans" }} numberOfLines={1}>
                    “Hari ini aku masak sup pertama kali, gagal keasinan...”
                  </Text>
                </View>
                <View className="self-center w-7 h-7 rounded-full bg-[#FDFCF8] border border-[#1B1C1A] items-center justify-center">
                  <ChevronRight size={14} color={C.ink} strokeWidth={2} />
                </View>
              </Pressable>
            </Link>
          </View>

          {/* ritual kecil - pencil progress (design.md progress = colored pencil) */}
          <View className="mt-5 bg-white rounded-[14px] border-[1.4px] border-[#1B1C1A] p-3.5 flex-row items-center gap-3" style={{ shadowColor: C.ink, shadowOpacity: 1, shadowRadius: 0, shadowOffset: { width: 3, height: 3 }, transform: [{ rotate: "0.3deg" }] }}>
            <View className="w-9 h-9 rounded-[10px] bg-[#B4EBFF] border border-[#1B1C1A] items-center justify-center">
              <Sparkles size={16} color={C.ink} strokeWidth={1.8} />
            </View>
            <View className="flex-1">
              <View className="flex-row items-center justify-between">
                <Text className="text-[13px] font-bold text-[#1B1C1A]" style={{ fontFamily: "Bricolage Grotesque" }}>
                  Ritual mingguan
                </Text>
                <Text className="text-[11px] font-bold text-[#864D61]" style={{ fontFamily: "Space Mono" }}>
                  4/7 hari
                </Text>
              </View>
              <View className="mt-1.5 h-2.5 rounded-full bg-[#FDFCF8] border border-[#1B1C1A] overflow-hidden flex-row">
                <View className="flex-[4] bg-[#93D4EB] border-r border-[#1B1C1A]" />
                <View className="flex-[3] bg-transparent" />
              </View>
              <Text className="mt-1 text-[11px] text-[#837377]" style={{ fontFamily: "Space Mono" }}>
                isi 3 hari lagi biar streak nggak putus
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
