import { useState } from "react";
import { View, Text, Pressable } from "react-native";
import Animated, { useSharedValue, useAnimatedStyle, withSpring, interpolate, runOnJS } from "react-native-reanimated";
import { Gesture, GestureDetector } from "react-native-gesture-handler";
import { ArrowRight, ChevronRight } from "lucide-react-native";

const C = { ink: "#1B1C1A" };

export function SwipeButton({ label, onComplete, hint = "GESER UNTUK MEMULAI" }: { label: string; onComplete: () => void; hint?: string }) {
  const [width, setWidth] = useState(340);
  const translateX = useSharedValue(0);
  const widthSV = useSharedValue(340);

  const THUMB = 52;
  const PADDING = 6;
  // MAX dihitung dari state width (JS thread) + di worklet dari widthSV untuk akurasi gesture
  const MAX = Math.max(0, width - THUMB - PADDING * 2);

  const pan = Gesture.Pan()
    .activeOffsetX([-10, 10])
    .failOffsetY([-12, 12])
    .shouldCancelWhenOutside(false)
    .onUpdate((e) => {
      const max = Math.max(0, widthSV.value - THUMB - PADDING * 2);
      translateX.value = Math.min(Math.max(0, e.translationX), max);
    })
    .onEnd(() => {
      const max = Math.max(0, widthSV.value - THUMB - PADDING * 2);
      if (translateX.value > max * 0.72) {
        translateX.value = withSpring(max, { damping: 18, stiffness: 260 });
        runOnJS(onComplete)();
        // reset setelah 800ms biar user lihat complete
        setTimeout(() => {
          translateX.value = withSpring(0, { damping: 18 });
        }, 800);
      } else {
        translateX.value = withSpring(0, { damping: 18, stiffness: 240 });
      }
    });

  const thumbStyle = useAnimatedStyle(() => ({ transform: [{ translateX: translateX.value }] }));
  const fillStyle = useAnimatedStyle(() => ({
    width: translateX.value + THUMB + PADDING,
    opacity: interpolate(translateX.value, [0, Math.max(1, MAX)], [0, 0.16]),
  }));
  const textStyle = useAnimatedStyle(() => ({
    opacity: interpolate(translateX.value, [0, Math.max(1, MAX * 0.45)], [1, 0]),
    transform: [{ translateX: interpolate(translateX.value, [0, Math.max(1, MAX)], [0, 10]) }],
  }));

  return (
    <View>
      <View
        onLayout={(e) => {
          const w = e.nativeEvent.layout.width;
          setWidth(w);
          widthSV.value = w;
        }}
        className="w-full h-[58px] rounded-full border-[1.6px] border-[#1B1C1A] bg-[#864D61] overflow-hidden"
        style={{ shadowColor: C.ink, shadowOpacity: 0.14, elevation: 3, shadowRadius: 0, shadowOffset: { width: 4, height: 4 } }}
      >
        <Animated.View className="absolute left-0 top-0 bottom-0 bg-white rounded-full" style={fillStyle} />
        <Animated.View className="absolute inset-0 items-center justify-center flex-row gap-1.5" style={textStyle} pointerEvents="none">
          <Text className="text-[16px] font-extrabold text-white tracking-[-0.2px]" style={{ fontFamily: "Bricolage Grotesque" }}>
            {label}
          </Text>
          <View className="flex-row opacity-60">
            <ChevronRight size={14} color="#fff" strokeWidth={2.5} />
            <ChevronRight size={14} color="#fff" strokeWidth={2.5} style={{ marginLeft: -6, opacity: 0.6 }} />
          </View>
        </Animated.View>
        <GestureDetector gesture={pan}>
          <Animated.View className="absolute left-[6px] top-[5px] w-[52px] h-[46px] rounded-full bg-white border-[1.5px] border-[#1B1C1A] items-center justify-center" style={thumbStyle}>
            <ArrowRight size={18} color={C.ink} strokeWidth={2.6} />
          </Animated.View>
        </GestureDetector>
        <Pressable onPress={onComplete} className="absolute right-0 top-0 bottom-0 w-12" style={{ opacity: 0 }} accessibilityLabel={label} />
      </View>
      <View className="flex-row items-center justify-center gap-1.5 mt-2.5">
        <Text className="text-[10px] tracking-[0.5px] text-[#837377]" style={{ fontFamily: "Space Mono" }}>
          {hint}
        </Text>
        <View className="flex-row">
          <ChevronRight size={11} color="#837377" strokeWidth={2} />
          <ChevronRight size={11} color="#837377" strokeWidth={2} style={{ marginLeft: -6, opacity: 0.5 }} />
        </View>
      </View>
    </View>
  );
}
