import { TactileDateField } from "@/components/ui/tactile-date-picker";
import { TactileTimeField } from "@/components/ui/tactile-time-picker";
import { TactileMapField } from "@/components/ui/tactile-map-picker";
import { WashiTape } from "@/components/ui/washi-tape";
import {
    CalendarHeart,
    Clock3,
    Heart,
    MapPin,
    PenLine,
    Plus,
    X,
} from "lucide-react-native";
import { useState } from "react";
import { useSafeAreaInsets } from "react-native-safe-area-context";
import {
    Modal,
    Pressable,
    ScrollView,
    Text,
    TextInput,
    View,
} from "react-native";

const C = {
  ink: "#1B1C1A",
  pink: "#FFD9E3",
  yellow: "#EEE199",
  blue: "#B4EBFF",
  mint: "#C6F0D1",
  error: "#ba1a1a",
  errorBg: "#ffdad6",
};

type DatePlan = {
  id: number;
  title: string;
  place: string;
  date: string;
  time: string;
  by: string;
  status: "menunggu" | "terjadwal" | "selesai";
  color: string;
  rot: string;
};

const INITIAL: DatePlan[] = [
  {
    id: 1,
    title: "Dinner anniversary 3 tahun",
    place: "SKYE Bar, Jakarta",
    date: "14 OKT",
    time: "19:30",
    by: "Bima",
    status: "terjadwal",
    color: "#FFD9E3",
    rot: "-0.6deg",
  },
  {
    id: 2,
    title: "Piknik sore di Taman Suropati",
    place: "Taman Suropati",
    date: "05 OKT",
    time: "16:00",
    by: "Alya",
    status: "menunggu",
    color: "#C6F0D1",
    rot: "0.5deg",
  },
  {
    id: 3,
    title: "Nonton bioskop - film baru",
    place: "CGV Grand Indonesia",
    date: "20 SEP",
    time: "20:00",
    by: "Kita",
    status: "selesai",
    color: "#B4EBFF",
    rot: "-0.4deg",
  },
];

const STATUS = {
  menunggu: { label: "MENUNGGU", bg: "#FFF0B3", border: "#1B1C1A" },
  terjadwal: {
    label: "TERJADWAL",
    bg: "#864D61",
    border: "#1B1C1A",
    text: "#fff",
  },
  selesai: {
    label: "SELESAI",
    bg: "#E8D9E0",
    border: "#D5C2C6",
    text: "#837377",
  },
};

export default function DateTab() {
  const insets = useSafeAreaInsets();
  const [dates, setDates] = useState<DatePlan[]>(INITIAL);
  const [showAdd, setShowAdd] = useState(false);
  const [title, setTitle] = useState("");
  const [place, setPlace] = useState("");
  const [date, setDate] = useState("");
  const [time, setTime] = useState("");
  const [by, setBy] = useState<"Alya" | "Bima" | "Kita">("Kita");
  const [errors, setErrors] = useState<{
    title?: string;
    place?: string;
    date?: string;
    time?: string;
  }>({});

  const handleSave = () => {
    const next: typeof errors = {};
    if (!title.trim()) next.title = "Judul kencan wajib diisi.";
    else if (title.trim().length < 3) next.title = "Minimal 3 karakter.";
    if (!place.trim()) next.place = "Tempat wajib diisi — di mana ketemuannya?";
    if (!date.trim()) next.date = "Tanggal wajib diisi — contoh: 28 OKT";
    if (!time.trim()) next.time = "Jam wajib diisi — contoh: 19:00";
    setErrors(next);
    if (Object.keys(next).length) return;

    const newDate: DatePlan = {
      id: Date.now(),
      title: title.trim(),
      place: place.trim(),
      date: date.trim().toUpperCase(),
      time: time.trim(),
      by,
      status: "menunggu",
      color: C.yellow,
      rot: `${(Math.random() * 1.2 - 0.6).toFixed(1)}deg`,
    };
    setDates((prev) => [newDate, ...prev]);
    setTitle("");
    setPlace("");
    setDate("");
    setTime("");
    setErrors({});
    setShowAdd(false);
  };

  const upcoming = dates.filter((d) => d.status !== "selesai").length;

  return (
    <View className="flex-1 bg-[#FDFCF8] overflow-hidden">
      <View pointerEvents="none" className="absolute inset-0 overflow-hidden">
        <View className="absolute -top-10 -right-10 w-48 h-48 rounded-full bg-[#B4EBFF] opacity-15" />
        <View className="absolute top-[300px] -left-10 w-40 h-40 rounded-full bg-[#FFD9E3] opacity-15" />
      </View>

      <ScrollView
        removeClippedSubviews
        showsVerticalScrollIndicator={false}
        showsHorizontalScrollIndicator={false}
        bounces={false}
        overScrollMode="never"
        contentContainerStyle={{ flexGrow: 1, paddingTop: insets.top + 16, paddingBottom: insets.bottom + 88, paddingHorizontal: 24 }} contentContainerClassName="grow"
       
      >
        <View className="w-full max-w-[400px] self-center">
          <View className="flex-row items-center gap-2">
            <View className="w-2 h-2 rounded-full bg-[#864D61]" />
            <Text
              className="text-[11px] font-bold tracking-[1px] text-[#864D61]"
              style={{ fontFamily: "Space Mono" }}
            >
              RUANG KITA • KENCAN
            </Text>
            <View className="ml-auto bg-[#1B1C1A] rounded-full px-2.5 py-1">
              <Text
                className="text-[10px] font-bold text-white"
                style={{ fontFamily: "Space Mono" }}
              >
                {upcoming} AKAN DATANG
              </Text>
            </View>
          </View>

          <Text
            className="mt-1.5 text-[28px] font-extrabold leading-[30px] tracking-[-1px] text-[#1B1C1A]"
            style={{ fontFamily: "Bricolage Grotesque" }}
          >
            Mau <Text className="text-[#864D61]">ketemu</Text> kapan?
          </Text>
          <Text
            className="mt-1.5 text-[13px] leading-5 text-[#514347]"
            style={{ fontFamily: "Plus Jakarta Sans" }}
          >
            Atur janji kencan — ajukan, setujui bareng, jadi tiket kecil yang
            ditempel di jurnal.
          </Text>

          <View className="mt-4 flex-row items-center gap-2">
            <View
              className="flex-1 bg-white border border-[#1B1C1A] rounded-full px-3 py-2.5 flex-row items-center gap-2"
              style={{
                shadowColor: C.ink,
                shadowOpacity: 1,
                shadowRadius: 0,
                shadowOffset: { width: 2, height: 2 },
              }}
            >
              <CalendarHeart size={14} color="#864D61" />
              <Text
                className="text-[12px] font-bold text-[#1B1C1A]"
                style={{ fontFamily: "Space Mono" }}
              >
                {upcoming} kencan • 1 butuh konfirmasi
              </Text>
            </View>
            <Pressable
              onPress={() => { setErrors({}); setShowAdd(true); }}
              className="w-[42px] h-[42px] rounded-full bg-[#864D61] border border-[#1B1C1A] items-center justify-center active:opacity-80"
              style={{
                shadowColor: C.ink,
                shadowOpacity: 1,
                shadowRadius: 0,
                shadowOffset: { width: 2, height: 2 },
              }}
            >
              <Plus size={18} color="#fff" strokeWidth={2.2} />
            </Pressable>
          </View>

          <View className="mt-5 gap-4">
            {dates.map((d) => {
              const st = STATUS[d.status];
              return (
                <View
                  key={d.id}
                  className="bg-white rounded-[16px] border-[1.5px] border-[#1B1C1A] p-3.5 overflow-visible"
                  style={{
                    shadowColor: C.ink,
                    shadowOpacity: 1,
                    shadowRadius: 0,
                    shadowOffset: { width: 3, height: 3 },
                    transform: [{ rotate: d.rot }],
                    overflow: "visible" as any,
                  }}
                >
                  <View className="absolute -top-1.5 left-4 z-10">
                    <WashiTape w={36} rotate="-3deg" color={d.color} />
                  </View>
                  <View className="flex-row items-start justify-between">
                    <View className="flex-row items-center gap-2.5">
                      <View
                        className="w-12 h-12 rounded-[10px] border border-[#1B1C1A] items-center justify-center"
                        style={{ backgroundColor: d.color }}
                      >
                        <Text
                          className="text-[11px] font-extrabold text-[#1B1C1A] text-center leading-[11px]"
                          style={{ fontFamily: "Space Mono" }}
                        >
                          {d.date.split(" ")[0]}
                          {"\n"}
                          {d.date.split(" ")[1]}
                        </Text>
                      </View>
                      <View>
                        <Text
                          className="text-[14px] font-bold leading-[16px] text-[#1B1C1A]"
                          style={{ fontFamily: "Bricolage Grotesque" }}
                        >
                          {d.title}
                        </Text>
                        <View className="flex-row items-center gap-1 mt-0.5">
                          <MapPin size={11} color="#837377" />
                          <Text
                            className="text-[11px] text-[#837377]"
                            style={{ fontFamily: "Space Mono" }}
                          >
                            {d.place}
                          </Text>
                        </View>
                      </View>
                    </View>
                    <View
                      className="rounded-full px-2 py-1 border"
                      style={{ backgroundColor: st.bg, borderColor: st.border }}
                    >
                      <Text
                        className="text-[9px] font-bold tracking-[0.5px]"
                        style={{
                          fontFamily: "Space Mono",
                          color: (st as any).text ?? C.ink,
                        }}
                      >
                        {st.label}
                      </Text>
                    </View>
                  </View>

                  <View className="mt-3 flex-row items-center gap-3">
                    <View className="flex-row items-center gap-1.5 bg-[#FDFCF8] border border-black/5 rounded-full px-2.5 py-1">
                      <Clock3 size={12} color="#837377" />
                      <Text
                        className="text-[11px] font-bold text-[#1B1C1A]"
                        style={{ fontFamily: "Space Mono" }}
                      >
                        {d.time}
                      </Text>
                    </View>
                    <Text
                      className="text-[11px] text-[#837377]"
                      style={{ fontFamily: "Space Mono" }}
                    >
                      diajak {d.by} • tap untuk{" "}
                      {d.status === "menunggu" ? "konfirmasi" : "detail"}
                    </Text>
                    {d.status === "menunggu" && (
                      <Pressable className="ml-auto bg-[#EEE199] border border-[#1B1C1A] rounded-full px-3 py-1.5">
                        <Text
                          className="text-[11px] font-bold text-[#1B1C1A]"
                          style={{ fontFamily: "Space Mono" }}
                        >
                          Setujui
                        </Text>
                      </Pressable>
                    )}
                  </View>
                </View>
              );
            })}
          </View>

          {/* empty helper */}
          <View
            className="mt-6 bg-[#EEE199] rounded-[12px] border border-[#1B1C1A] px-3.5 py-3 flex-row items-center gap-2.5"
            style={{ transform: [{ rotate: "-0.3deg" }] }}
          >
            <View className="w-8 h-8 rounded-full bg-white border border-[#1B1C1A] items-center justify-center">
              <Heart size={14} color={C.ink} fill={C.pink} />
            </View>
            <Text
              className="flex-1 text-[12px] leading-[16px] text-[#1B1C1A]"
              style={{ fontFamily: "Space Mono" }}
            >
              Tip: tambahkan kencan sebagai{" "}
              <Text className="font-bold">tiket</Text> — nanti jadi kenangan
              otomatis setelah lewat.
            </Text>
          </View>
        </View>
      </ScrollView>

      {/* Add Date Sheet */}
      <Modal
        visible={showAdd}
        animationType="slide"
        transparent
        onRequestClose={() => { setErrors({}); setShowAdd(false); }}
        statusBarTranslucent
      >
        <View className="flex-1 bg-[#1B1C1A]/40 justify-end">
          <Pressable className="flex-1" onPress={() => setShowAdd(false)} />
          <View
            className="bg-[#FDFCF8] rounded-t-[20px] border-t-[1.5px] border-x-[1.5px] border-[#1B1C1A] px-6 pt-5 pb-6 max-h-[88%]"
            style={{
              shadowColor: C.ink,
              shadowOpacity: 1,
              shadowRadius: 0,
              shadowOffset: { width: 0, height: -4 },
            }}
          >
            <View className="absolute -top-2 left-1/2 -translate-x-1/2 z-10">
              <WashiTape w={56} rotate="-2deg" color={C.yellow} />
            </View>
            <View className="w-10 h-1.5 rounded-full bg-[#1B1C1A] opacity-20 self-center mb-4" />

            <View className="flex-row items-center justify-between">
              <View className="flex-row items-center gap-2">
                <View className="w-8 h-8 rounded-full bg-[#B4EBFF] border border-[#1B1C1A] items-center justify-center">
                  <CalendarHeart size={14} color={C.ink} strokeWidth={1.8} />
                </View>
                <View>
                  <Text
                    className="text-[16px] font-extrabold text-[#1B1C1A]"
                    style={{ fontFamily: "Bricolage Grotesque" }}
                  >
                    Ajak kencan
                  </Text>
                  <Text
                    className="text-[11px] text-[#837377]"
                    style={{ fontFamily: "Space Mono" }}
                  >
                    Buat tiket kencan untuk ditempel
                  </Text>
                </View>
              </View>
              <Pressable
                onPress={() => setShowAdd(false)}
                className="w-8 h-8 rounded-full bg-white border border-[#1B1C1A] items-center justify-center"
              >
                <X size={16} color={C.ink} strokeWidth={2} />
              </Pressable>
            </View>

            <ScrollView
              showsVerticalScrollIndicator={false}
              className="mt-5"
              contentContainerClassName="gap-4 pb-2"
            >
              <View className="flex-row gap-2">
                {(["Kita", "Alya", "Bima"] as const).map((a) => (
                  <Pressable
                    key={a}
                    onPress={() => setBy(a)}
                    className="flex-1 rounded-full border py-2 items-center"
                    style={{
                      backgroundColor: by === a ? C.ink : "#fff",
                      borderColor: C.ink,
                      borderWidth: 1.4,
                    }}
                  >
                    <Text
                      className="text-[12px] font-bold"
                      style={{
                        fontFamily: "Space Mono",
                        color: by === a ? "#fff" : C.ink,
                      }}
                    >
                      {a.toUpperCase()}
                    </Text>
                  </Pressable>
                ))}
              </View>

              <View className="gap-1.5">
                <View className="flex-row items-center gap-1.5">
                  <PenLine
                    size={13}
                    color={errors.title ? C.error : "#837377"}
                  />
                  <Text
                    className="text-[11px] font-bold tracking-[0.7px]"
                    style={{
                      fontFamily: "Space Mono",
                      color: errors.title ? C.error : "#837377",
                    }}
                  >
                    MAU NGAPAIN?
                  </Text>
                </View>
                <View
                  className="flex-row items-end gap-2 border-b-[1.6px] pb-2 pt-1"
                  style={{ borderColor: errors.title ? C.error : C.ink }}
                >
                  <TextInput
                    value={title}
                    onChangeText={(v) => {
                      setTitle(v);
                      if (errors.title)
                        setErrors((p) => ({ ...p, title: undefined }));
                    }}
                    placeholder="Contoh: Dinner anniversary"
                    placeholderTextColor="#B8A9AC"
                    className="flex-1 text-[15px] p-0"
                    style={{
                      fontFamily: "Bricolage Grotesque",
                      paddingVertical: 0,
                      color: errors.title ? C.error : C.ink,
                    }}
                  />
                </View>
                {errors.title && (
                  <View
                    className="rounded-[8px] border px-2.5 py-1.5"
                    style={{
                      backgroundColor: C.errorBg,
                      borderColor: "#E8B4B0",
                    }}
                  >
                    <Text
                      className="text-[11px]"
                      style={{ fontFamily: "Space Mono", color: "#93000a" }}
                    >
                      {errors.title}
                    </Text>
                  </View>
                )}
              </View>

              <View className="flex-row gap-3">
                <View className="flex-1">
                  <TactileDateField
                    value={date}
                    onChange={(v) => {
                      setDate(v);
                      if (errors.date)
                        setErrors((p) => ({ ...p, date: undefined }));
                    }}
                    error={errors.date}
                  />
                </View>
                <View className="flex-1">
                  <TactileTimeField
                    value={time}
                    onChange={(v) => {
                      setTime(v);
                      if (errors.time)
                        setErrors((p) => ({ ...p, time: undefined }));
                    }}
                    error={errors.time}
                  />
                </View>
              </View>

              <TactileMapField
                value={place}
                onChange={(v) => {
                  setPlace(v);
                  if (errors.place) setErrors((p) => ({ ...p, place: undefined }));
                }}
                error={errors.place}
              />

              <Pressable
                onPress={handleSave}
                className="mt-2 bg-[#864D61] rounded-full border-[1.6px] border-[#1B1C1A] py-3.5 flex-row items-center justify-center gap-2 active:opacity-90"
                style={{
                  shadowColor: C.ink,
                  shadowOpacity: 1,
                  shadowRadius: 0,
                  shadowOffset: { width: 3, height: 3 },
                }}
              >
                <Text
                  className="text-[15px] font-extrabold text-white"
                  style={{ fontFamily: "Bricolage Grotesque" }}
                >
                  Buat tiket kencan
                </Text>
                <View className="w-6 h-6 rounded-full bg-white items-center justify-center">
                  <CalendarHeart size={12} color={C.ink} strokeWidth={2} />
                </View>
              </Pressable>
            </ScrollView>
          </View>
        </View>
      </Modal>
    </View>
  );
}
