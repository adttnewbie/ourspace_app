import { View, Text, Pressable } from "react-native";
import { useSafeAreaInsets } from "react-native-safe-area-context";
import { House, Images, CalendarHeart, User } from "lucide-react-native";

const C = {
  ink: "#1B1C1A",
  primary: "#864D61",
  pink: "#FFB7CE",
  pinkDeep: "#FFD9E3",
  yellow: "#EEE199",
  blue: "#B4EBFF",
  outline: "#D5C2C6",
};

const TABS: Record<string, { label: string; Icon: any; activeBg: string }> = {
  home: { label: "Ruang", Icon: House, activeBg: C.pink },
  memories: { label: "Kenangan", Icon: Images, activeBg: C.yellow },
  timeline: { label: "Jejak", Icon: CalendarHeart, activeBg: C.blue },
  profile: { label: "Kita", Icon: User, activeBg: "#E8D9E0" },
};

export function BookmarkBar({ state, descriptors, navigation }: any) {
  const insets = useSafeAreaInsets();

  return (
    <View pointerEvents="box-none" className="absolute left-0 right-0 items-center" style={{ bottom: Math.max(insets.bottom, 12) }}>
      {/* shadow paper underneath */}
      <View
        className="w-[92%] max-w-[380px] h-[68px] rounded-full bg-white border-[1.6px] border-[#1B1C1A] flex-row items-center px-2"
        style={{
          shadowColor: C.ink,
          shadowOpacity: 1,
          shadowRadius: 0,
          shadowOffset: { width: 4, height: 4 },
          transform: [{ rotate: "-0.2deg" }],
        }}
      >
        {/* bookmark notches - two small triangles at top edge */}
        <View className="absolute -top-[7px] left-[22%] w-3 h-3 bg-[#FDFCF8] border-l border-b border-[#1B1C1A] rotate-45" />
        <View className="absolute -top-[7px] right-[22%] w-3 h-3 bg-[#FDFCF8] border-l border-b border-[#1B1C1A] rotate-45" />
        {/* washi tape center */}
        <View className="absolute -top-2 left-1/2 -translate-x-1/2 h-[12px] w-[48px] bg-[#EEE199] border border-black/5 opacity-90 rounded-sm" style={{ transform: [{ rotate: "-2deg" }] }}>
          <View className="flex-1 border-t border-white/50 mt-[2px]" />
        </View>
        {/* fabric texture line */}
        <View className="absolute left-4 right-4 top-[10px] h-[1px] bg-[#1B1C1A] opacity-[0.04]" />

        {state.routes.map((route: any, index: number) => {
          const isFocused = state.index === index;
          const cfg = TABS[route.name] ?? { label: route.name, Icon: House, activeBg: C.pink };
          const { Icon } = cfg;

          const onPress = () => {
            const event = navigation.emit({ type: "tabPress", target: route.key, canPreventDefault: true });
            if (!isFocused && !event.defaultPrevented) navigation.navigate(route.name);
          };

          return (
            <Pressable
              key={route.key}
              onPress={onPress}
              accessibilityRole="button"
              accessibilityState={isFocused ? { selected: true } : {}}
              className="flex-1 items-center justify-center gap-1 py-1"
            >
              <View
                className="w-[52px] h-[36px] rounded-full border items-center justify-center"
                style={{
                  backgroundColor: isFocused ? cfg.activeBg : "transparent",
                  borderColor: isFocused ? C.ink : "transparent",
                  borderWidth: isFocused ? 1.4 : 0,
                  transform: [{ rotate: isFocused ? "-0.6deg" : "0deg" }, { scale: isFocused ? 1.02 : 1 }],
                }}
              >
                <Icon size={20} color={isFocused ? C.ink : "#837377"} strokeWidth={isFocused ? 2.1 : 1.8} fill={isFocused ? "rgba(27,28,26,0.06)" : "transparent"} />
              </View>
              <Text
                className="text-[10px] leading-none tracking-[0.4px]"
                style={{
                  fontFamily: "Space Mono",
                  fontWeight: isFocused ? "700" : "600",
                  color: isFocused ? C.ink : "#837377",
                }}
              >
                {cfg.label}
              </Text>
              {isFocused && <View className="w-1 h-1 rounded-full bg-[#864D61] mt-[1px]" />}
            </Pressable>
          );
        })}
      </View>
      {/* bottom safe padding */}
      <View style={{ height: 2 }} />
    </View>
  );
}
