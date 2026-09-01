import { useCallback, useState } from "react";
import { View, Text, Pressable, ScrollView } from "react-native";
import { useSafeAreaInsets } from "react-native-safe-area-context";
import { Link, useRouter } from "expo-router";
import Animated, { useSharedValue, useAnimatedStyle, withSpring, interpolate } from "react-native-reanimated";
import { ArrowLeftRight, Sparkles, Heart, Lock } from "lucide-react-native";
import { WashiTape } from "@/components/ui/washi-tape";
import { SwipeButton } from "@/components/ui/swipe-button";

const C = {
  cream: "#FDFCF8",
  ink: "#1B1C1A",
  muted: "#514347",
  primary: "#864D61",
  pink: "#FFB7CE",
  pinkSoft: "#FFD9E3",
  yellow: "#EEE199",
  blue: "#93D4EB",
  blueSoft: "#B4EBFF",
  outline: "#D5C2C6",
  outlineStrong: "#837377",
};



export default function GetStartedPage() {
  const insets = useSafeAreaInsets();
  const router = useRouter();
  const [swapped, setSwapped] = useState(false);
  const progress = useSharedValue(0);
  const btnScale = useSharedValue(1);

  const toggleSwap = useCallback(() => {
    setSwapped((s) => !s);
    progress.value = withSpring(swapped ? 0 : 1, { damping: 14, stiffness: 180 });
    btnScale.value = withSpring(0.92, { damping: 10 }, () => {
      btnScale.value = withSpring(1, { damping: 8, stiffness: 200 });
    });
  }, [swapped, progress, btnScale]);

  const leftStyle = useAnimatedStyle(() => {
    const t = progress.value;
    return {
      transform: [
        { translateX: interpolate(t, [0, 1], [0, 18]) },
        { rotate: `${interpolate(t, [0, 1], [-1.6, 1.6])}deg` },
      ],
      zIndex: interpolate(t, [0, 1], [2, 1]),
    };
  });
  const rightStyle = useAnimatedStyle(() => {
    const t = progress.value;
    return {
      transform: [
        { translateX: interpolate(t, [0, 1], [0, -18]) },
        { rotate: `${interpolate(t, [0, 1], [1.6, -1.6])}deg` },
      ],
      zIndex: interpolate(t, [0, 1], [1, 2]),
    };
  });
  const btnAnim = useAnimatedStyle(() => ({
    transform: [{ scale: btnScale.value }, { rotate: `${interpolate(progress.value, [0, 1], [0, 180])}deg` }],
  }));

  const left = swapped
    ? { name: "Kamu", label: "PARTNER", color: C.blue, soft: C.blueSoft, Icon: Heart }
    : { name: "Aku", label: "YOU", color: C.pink, soft: C.pinkSoft, Icon: Sparkles };
  const right = swapped
    ? { name: "Aku", label: "YOU", color: C.pink, soft: C.pinkSoft, Icon: Sparkles }
    : { name: "Kamu", label: "PARTNER", color: C.blue, soft: C.blueSoft, Icon: Heart };

  const handleSwipeComplete = useCallback(() => router.push("/register"), [router]);

  return (
    <View className="flex-1 bg-[#FDFCF8] overflow-hidden">
      <View pointerEvents="none" className="absolute inset-0 overflow-hidden">
        <View className="absolute -top-20 -right-16 w-[240px] h-[240px] rounded-full bg-[#FFD9E3] opacity-[0.12]" />
        <View className="absolute top-[260px] -left-16 w-[200px] h-[200px] rounded-full bg-[#B4EBFF] opacity-[0.10]" />
        <View className="absolute bottom-24 right-6 w-32 h-32 rounded-full bg-[#EEE199] opacity-[0.08]" />
        <Text
          numberOfLines={1}
          className="absolute left-0 right-0 text-center text-[180px] font-extrabold text-[#1B1C1A] opacity-[0.025] top-[52%] -translate-y-1/2"
          style={{ fontFamily: "Bricolage Grotesque" }}
        >
          01
        </Text>
      </View>

      <ScrollView
        showsVerticalScrollIndicator={false}
        showsHorizontalScrollIndicator={false}
        horizontal={false}
        bounces={false}
        overScrollMode="never"
        removeClippedSubviews
        keyboardShouldPersistTaps="handled"
        contentContainerStyle={{ flexGrow: 1, paddingTop: insets.top + 16, paddingBottom: insets.bottom + 16, paddingHorizontal: 24 }}
        contentContainerClassName="grow"
      >
        <View className="flex-1 w-full max-w-[400px] mx-auto">
          <View className="flex-row items-center justify-between">
            <View className="flex-row items-center gap-2">
              <View className="w-2 h-2 rounded-full bg-[#864D61]" />
              <Text className="text-[10px] font-bold tracking-[1.4px] text-[#837377]" style={{ fontFamily: "Space Mono" }}>
                OURSPACE
              </Text>
              <View className="w-[18px] h-[1px] bg-[#D5C2C6] opacity-60 ml-1" />
              <View className="flex-row items-center gap-1">
                <Lock size={10} color={C.outlineStrong} strokeWidth={1.8} />
                <Text className="text-[10px] text-[#837377]" style={{ fontFamily: "Space Mono" }}>
                  PRIVATE
                </Text>
              </View>
            </View>
            <Text className="text-[11px] text-[#837377]" style={{ fontFamily: "Space Mono" }}>
              01 / 03
            </Text>
          </View>

          <View className="mt-7">
            <Text className="text-[40px] font-extrabold leading-[42px] tracking-[-1.4px] text-[#1B1C1A]" style={{ fontFamily: "Bricolage Grotesque" }}>
              Ruang kita,{"\n"}
              <Text className="text-[#864D61]">cerita kita.</Text>
            </Text>
            <View className="mt-2 flex-row items-center gap-2">
              <View className="w-[132px] h-[7px] bg-[#FFB7CE] rounded-full opacity-90" style={{ transform: [{ rotate: "-0.6deg" }] }} />
              <Text className="text-[11px] text-[#837377] italic" style={{ fontFamily: "Bricolage Grotesque" }}>
                — untuk berdua
              </Text>
            </View>
            <Text className="mt-3 text-[15px] leading-6 text-[#514347] max-w-[320px]" style={{ fontFamily: "Plus Jakarta Sans" }}>
              Jurnal privat untuk berdua — simpan foto & cerita di satu tempat yang aman.
            </Text>
          </View>

          <View
            className="mt-6 bg-white rounded-[20px] border-[1.5px] border-[#1B1C1A] p-3.5 overflow-visible"
            style={{ shadowColor: C.ink, shadowOpacity: 0.14, elevation: 3, shadowRadius: 0, shadowOffset: { width: 4, height: 4 }, overflow: "visible" as any }}
          >
            <View className="absolute -top-2 left-7 z-10">
              <WashiTape w={52} rotate="-3deg" color={C.yellow} />
            </View>

            <View className="h-[168px] flex-row items-center justify-center">
              <Animated.View className="flex-1 h-[154px]" style={leftStyle}>
                <View
                  className="flex-1 bg-white rounded-2xl border-[1.5px] border-[#1B1C1A] p-2.5 overflow-visible"
                  style={{ shadowColor: C.ink, shadowOpacity: 0.14, elevation: 3, shadowRadius: 0, shadowOffset: { width: 3, height: 3 }, overflow: "visible" as any }}
                >
                  <View className="absolute -top-1.5 left-4 z-10">
                    <WashiTape w={40} rotate={swapped ? "3deg" : "-4deg"} color={left.color} />
                  </View>
                  <View className="flex-1 rounded-xl border border-black/5 items-center justify-center gap-1" style={{ backgroundColor: left.soft }}>
                    <left.Icon size={28} color={C.ink} strokeWidth={1.7} />
                    <Text className="text-[10px] font-bold tracking-[1px] text-[#1B1C1A]" style={{ fontFamily: "Space Mono" }}>
                      {left.label}
                    </Text>
                  </View>
                  <Text className="mt-2 text-center text-[15px] font-bold text-[#1B1C1A]" style={{ fontFamily: "Bricolage Grotesque" }}>
                    {left.name}
                  </Text>
                </View>
              </Animated.View>

              <View className="absolute z-10 items-center justify-center">
                <View className="absolute w-[60px] h-[60px] rounded-full bg-[#1B1C1A] translate-x-[2.5px] translate-y-[2.5px]" />
                <Pressable onPress={toggleSwap} className="w-[58px] h-[58px] rounded-full bg-[#F1E39C] border-[1.6px] border-[#1B1C1A] items-center justify-center active:opacity-80">
                  <Animated.View className="items-center justify-center gap-[1px]" style={btnAnim}>
                    <ArrowLeftRight size={18} color={C.ink} strokeWidth={2.2} />
                    <Text className="text-[7px] font-extrabold tracking-[0.8px] text-[#1B1C1A]" style={{ fontFamily: "Space Mono" }}>
                      SWAP
                    </Text>
                  </Animated.View>
                </Pressable>
              </View>

              <Animated.View className="flex-1 h-[154px]" style={rightStyle}>
                <View
                  className="flex-1 bg-white rounded-2xl border-[1.5px] border-[#1B1C1A] p-2.5 overflow-visible"
                  style={{ shadowColor: C.ink, shadowOpacity: 0.14, elevation: 3, shadowRadius: 0, shadowOffset: { width: 3, height: 3 }, overflow: "visible" as any }}
                >
                  <View className="absolute -top-1.5 right-4 z-10">
                    <WashiTape w={40} rotate={swapped ? "-4deg" : "3deg"} color={right.color} />
                  </View>
                  <View className="flex-1 rounded-xl border border-black/5 items-center justify-center gap-1" style={{ backgroundColor: right.soft }}>
                    <right.Icon size={28} color={C.ink} strokeWidth={1.7} />
                    <Text className="text-[10px] font-bold tracking-[1px] text-[#1B1C1A]" style={{ fontFamily: "Space Mono" }}>
                      {right.label}
                    </Text>
                  </View>
                  <Text className="mt-2 text-center text-[15px] font-bold text-[#1B1C1A]" style={{ fontFamily: "Bricolage Grotesque" }}>
                    {right.name}
                  </Text>
                </View>
              </Animated.View>
            </View>

            <Text className="mt-2 text-center text-[11px] text-[#837377]" style={{ fontFamily: "Space Mono" }}>
              Tap <Text className="font-bold text-[#1B1C1A]">SWAP</Text> untuk tukar posisi
            </Text>
          </View>

          <View className="mt-4 flex-row items-center gap-3">
            <View className="flex-1 h-[1px] bg-[#D5C2C6] opacity-30" />
            <View className="bg-white border border-[#D5C2C6] rounded-full px-3 py-1.5 flex-row items-center gap-1.5" style={{ transform: [{ rotate: "-0.6deg" }] }}>
              <Text className="text-[11px] text-[#514347]" style={{ fontFamily: "Bricolage Grotesque", fontStyle: "italic" }}>
                one day at a time
              </Text>
              <Heart size={10} color={C.primary} fill={C.pink} strokeWidth={1.6} />
            </View>
            <View className="flex-1 h-[1px] bg-[#D5C2C6] opacity-30" />
          </View>

          <View className="flex-1 min-h-[12px]" />

          <View className="mt-4 gap-3">
            <SwipeButton label="Mulai ruang kita" onComplete={handleSwipeComplete} hint="GESER UNTUK MEMULAI" />
            <Link href="/login" asChild>
              <Pressable className="py-1 items-center">
                <Text className="text-[13px] font-bold text-[#514347]" style={{ fontFamily: "Space Mono" }}>
                  Sudah punya ruang? <Text className="text-[#1B1C1A] underline">Masuk</Text>
                </Text>
              </Pressable>
            </Link>
          </View>
        </View>
      </ScrollView>
    </View>
  );
}
