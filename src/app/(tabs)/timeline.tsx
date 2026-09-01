import { View, Text, ScrollView } from "react-native";
import { CalendarHeart, Heart } from "lucide-react-native";

export default function TimelineTab() {
  return (
    <View className="flex-1 bg-[#FDFCF8]">
      <ScrollView showsVerticalScrollIndicator={false} contentContainerClassName="px-6 pt-14 pb-28" bounces={false}>
        <View className="w-full max-w-[400px] self-center">
          <Text className="text-[28px] font-extrabold tracking-[-1px] text-[#1B1C1A]" style={{ fontFamily: "Bricolage Grotesque" }}>
            Jejak waktu
          </Text>
          <Text className="mt-1 text-[13px] leading-5 text-[#514347]" style={{ fontFamily: "Plus Jakarta Sans" }}>
            Linimasa privat — anniversary, janji kecil, dan target berdua.
          </Text>

          <View className="mt-6 gap-3">
            {[
              { d: "14 SEP", t: "Anniversary 5 bulan", c: "#FFD9E3" },
              { d: "02 SEP", t: "Nabung trip Jogja", c: "#EEE199" },
              { d: "18 AUG", t: "Hari pertama OurSpace", c: "#B4EBFF" },
            ].map((it) => (
              <View key={it.d} className="bg-white rounded-[14px] border-[1.5px] border-[#1B1C1A] p-4 flex-row items-center gap-3" style={{ shadowColor: "#1B1C1A", shadowOpacity: 1, shadowRadius: 0, shadowOffset: { width: 3, height: 3 } }}>
                <View className="w-12 h-12 rounded-[10px] border border-[#1B1C1A] items-center justify-center" style={{ backgroundColor: it.c }}>
                  <Text className="text-[10px] font-bold text-[#1B1C1A] text-center" style={{ fontFamily: "Space Mono" }}>
                    {it.d}
                  </Text>
                </View>
                <View className="flex-1">
                  <Text className="text-[14px] font-bold text-[#1B1C1A]" style={{ fontFamily: "Bricolage Grotesque" }}>
                    {it.t}
                  </Text>
                  <Text className="text-[12px] text-[#837377]" style={{ fontFamily: "Space Mono" }}>
                    08:00 • pengingat aktif
                  </Text>
                </View>
                <Heart size={16} color="#864D61" fill="#FFB7CE" />
              </View>
            ))}
          </View>

          <View className="mt-4 h-[6px] rounded-full bg-[#1B1C1A] opacity-10 overflow-hidden">
            <View className="h-full w-[62%] bg-[#864D61] rounded-full" />
          </View>
          <Text className="mt-1 text-[11px] text-[#837377] text-center" style={{ fontFamily: "Space Mono" }}>
            62% perjalanan tahun ini terisi
          </Text>
        </View>
      </ScrollView>
    </View>
  );
}
