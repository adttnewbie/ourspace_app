import { View } from "react-native";
const C = { yellow: "#EEE199" };
export function WashiTape({ w = 52, rotate = "-3deg", color = C.yellow }: { w?: number; rotate?: string; color?: string }) {
  return (
    <View className="h-[14px] border border-black/5 opacity-90" style={{ width: w, backgroundColor: color, transform: [{ rotate }] }}>
      <View className="flex-1 border-t border-white/50 mt-[2px]" />
    </View>
  );
}
