import { useState } from "react";
import { useSafeAreaInsets } from "react-native-safe-area-context";
import { View, Text, ScrollView, Pressable, Modal, TextInput } from "react-native";
import { Images, Heart, Search, Plus, X, Camera, PenLine, Check } from "lucide-react-native";
import { WashiTape } from "@/components/ui/washi-tape";

const C = { ink: "#1B1C1A", pink: "#FFD9E3", yellow: "#EEE199", blue: "#B4EBFF", mint: "#C6F0D1", error: "#ba1a1a", errorBg: "#ffdad6" };

type Tile = { id: number; date: string; title: string; color: string; rot: string; author: string };

const INITIAL: Tile[] = [
  { id: 1, date: "28 AUG", title: "Pantai jam 5 sore", color: "#FFD9E3", rot: "-0.8deg", author: "Alya" },
  { id: 2, date: "22 AUG", title: "Masak bareng — gagal tapi enak", color: "#EEE199", rot: "0.7deg", author: "Bima" },
  { id: 3, date: "15 AUG", title: "Nonton hujan dari jendela", color: "#B4EBFF", rot: "-0.5deg", author: "Kita" },
];

const COLORS = [
  { hex: "#FFD9E3", label: "PINK" },
  { hex: "#EEE199", label: "KUNING" },
  { hex: "#B4EBFF", label: "BIRU" },
  { hex: "#C6F0D1", label: "MINT" },
];

export default function MemoriesTab() {
  const insets = useSafeAreaInsets();
  const [tiles, setTiles] = useState<Tile[]>(INITIAL);
  const [showAdd, setShowAdd] = useState(false);
  const [title, setTitle] = useState("");
  const [caption, setCaption] = useState("");
  const [color, setColor] = useState(C.pink);
  const [author, setAuthor] = useState<"Alya" | "Bima" | "Kita">("Alya");
  const [errors, setErrors] = useState<{ title?: string; caption?: string }>({});
  const [q, setQ] = useState("");

  const filtered = tiles.filter((t) => !q || t.title.toLowerCase().includes(q.toLowerCase()) || t.author.toLowerCase().includes(q.toLowerCase()));

  const handleSave = () => {
    const next: typeof errors = {};
    if (!title.trim()) next.title = "Judul foto wajib diisi.";
    else if (title.trim().length < 3) next.title = "Minimal 3 karakter.";
    if (!caption.trim()) next.caption = "Cerita singkat wajib diisi — 1 kalimat cukup.";
    else if (caption.trim().length < 8) next.caption = "Minimal 8 karakter.";
    setErrors(next);
    if (Object.keys(next).length) return;

    const now = new Date();
    const date = `${String(now.getDate()).padStart(2, "0")} ${now.toLocaleString("en-US", { month: "short" }).toUpperCase()}`;
    const newTile: Tile = {
      id: Date.now(),
      date,
      title: title.trim(),
      color,
      rot: `${(Math.random() * 1.4 - 0.7).toFixed(1)}deg`,
      author,
    };
    setTiles((prev) => [newTile, ...prev]);
    setTitle("");
    setCaption("");
    setErrors({});
    setShowAdd(false);
  };

  return (
    <View className="flex-1 bg-[#FDFCF8] overflow-hidden">
      <View pointerEvents="none" className="absolute inset-0 overflow-hidden">
        <View className="absolute -top-10 -right-10 w-48 h-48 rounded-full bg-[#FFD9E3] opacity-15" />
        <View className="absolute top-[300px] -left-10 w-40 h-40 rounded-full bg-[#EEE199] opacity-12" />
      </View>

      <ScrollView
        removeClippedSubviews showsVerticalScrollIndicator={false} showsHorizontalScrollIndicator={false} bounces={false} overScrollMode="never" contentContainerStyle={{ flexGrow: 1, paddingTop: insets.top + 16, paddingBottom: insets.bottom + 88, paddingHorizontal: 24 }} contentContainerClassName="grow">
        <View className="w-full max-w-[400px] self-center">
          <Text className="text-[11px] font-bold tracking-[1px] text-[#864D61]" style={{ fontFamily: "Space Mono" }}>
            KOLEKSI • {tiles.length} KENANGAN
          </Text>
          <Text className="text-[28px] font-extrabold tracking-[-1px] text-[#1B1C1A] mt-1" style={{ fontFamily: "Bricolage Grotesque" }}>
            Kenangan
          </Text>
          <Text className="mt-1 text-[13px] leading-5 text-[#514347]" style={{ fontFamily: "Plus Jakarta Sans" }}>
            Polaroid yang ditempel bareng — tiap foto punya cerita di baliknya.
          </Text>

          <View className="mt-4 flex-row items-center gap-2">
            <View className="flex-1 flex-row items-center gap-2 bg-white border border-[#1B1C1A] rounded-full px-3 py-2" style={{ shadowColor: C.ink, shadowOpacity: 0.14, elevation: 3, shadowRadius: 0, shadowOffset: { width: 2, height: 2 } }}>
              <Search size={14} color="#837377" />
              <TextInput
                value={q}
                onChangeText={setQ}
                placeholder="Cari foto, judul..."
                placeholderTextColor="#B8A9AC"
                className="flex-1 text-[13px] p-0"
                style={{ fontFamily: "Space Mono", paddingVertical: 0 }}
              />
              {q.length > 0 && (
                <Pressable onPress={() => setQ("")} className="w-6 h-6 rounded-full bg-[#FDFCF8] border border-[#D5C2C6] items-center justify-center">
                  <X size={12} color="#837377" />
                </Pressable>
              )}
            </View>
            <Pressable onPress={() => { setErrors({}); setShowAdd(true); }} className="w-[42px] h-[42px] rounded-full bg-[#864D61] border border-[#1B1C1A] items-center justify-center active:opacity-80" style={{ shadowColor: C.ink, shadowOpacity: 0.14, elevation: 3, shadowRadius: 0, shadowOffset: { width: 2, height: 2 } }}>
              <Plus size={18} color="#fff" strokeWidth={2.2} />
            </Pressable>
          </View>

          {filtered.length === 0 ? (
            <View className="mt-8 bg-white rounded-[16px] border-[1.5px] border-[#1B1C1A] border-dashed p-6 items-center" style={{ transform: [{ rotate: "-0.3deg" }] }}>
              <View className="w-10 h-10 rounded-full bg-[#FDFCF8] border border-[#1B1C1A] items-center justify-center">
                <Images size={18} color={C.ink} />
              </View>
              <Text className="mt-3 text-[14px] font-bold text-[#1B1C1A]" style={{ fontFamily: "Bricolage Grotesque" }}>
                Tidak ada hasil
              </Text>
              <Text className="text-[12px] text-[#837377] text-center mt-1" style={{ fontFamily: "Space Mono" }}>
                Coba kata kunci lain atau tambah foto baru.
              </Text>
            </View>
          ) : (
            <View className="mt-6 gap-4">
              {filtered.map((t) => (
                <View key={t.id} className="bg-white rounded-[16px] border-[1.5px] border-[#1B1C1A] p-3 overflow-visible" style={{ shadowColor: C.ink, shadowOpacity: 0.14, elevation: 3, shadowRadius: 0, shadowOffset: { width: 4, height: 4 }, transform: [{ rotate: t.rot }], overflow: "visible" as any }}>
                  <View className="absolute -top-2 left-5 z-10">
                    <WashiTape w={42} rotate="-3deg" color={t.color} />
                  </View>
                  <View className="h-[148px] rounded-xl border border-black/5 items-center justify-center gap-1.5" style={{ backgroundColor: t.color }}>
                    <View className="w-[72px] h-[72px] rounded-[12px] bg-white border border-[#1B1C1A] items-center justify-center" style={{ transform: [{ rotate: "-1deg" }] }}>
                      <Camera size={22} color={C.ink} strokeWidth={1.6} />
                    </View>
                    <Text className="text-[10px] font-bold tracking-[1px] text-[#1B1C1A]" style={{ fontFamily: "Space Mono" }}>
                      {t.date} • {t.author.toUpperCase()}
                    </Text>
                  </View>
                  <Text className="mt-2.5 text-[15px] font-bold leading-[18px] text-[#1B1C1A]" style={{ fontFamily: "Bricolage Grotesque" }}>
                    {t.title}
                  </Text>
                  <View className="mt-1.5 flex-row items-center gap-1.5">
                    <View className="bg-[#1B1C1A] rounded-full px-2 py-1">
                      <Text className="text-[10px] font-bold text-white" style={{ fontFamily: "Space Mono" }}>
                        FOTO
                      </Text>
                    </View>
                    <Text className="text-[11px] text-[#837377]" style={{ fontFamily: "Space Mono" }}>
                      tap untuk lihat cerita
                    </Text>
                    <Heart size={12} color="#864D61" fill="#FFB7CE" style={{ marginLeft: "auto" }} />
                  </View>
                </View>
              ))}
            </View>
          )}

          <View className="mt-6 flex-row items-center gap-2">
            <View className="flex-1 h-[1px] bg-[#D5C2C6] opacity-30" />
            <Text className="text-[11px] italic text-[#837377]" style={{ fontFamily: "Bricolage Grotesque" }}>
              simpan tiap momen
            </Text>
            <Heart size={10} color="#864D61" fill="#FFB7CE" />
            <View className="flex-1 h-[1px] bg-[#D5C2C6] opacity-30" />
          </View>
        </View>
      </ScrollView>

      {/* Add Photo Sheet - polaroid composer */}
      <Modal visible={showAdd} animationType="slide" transparent onRequestClose={() => { setErrors({}); setShowAdd(false); }} statusBarTranslucent>
        <View className="flex-1 bg-[#1B1C1A]/40 justify-end">
          <Pressable className="flex-1" onPress={() => setShowAdd(false)} />
          <View className="bg-[#FDFCF8] rounded-t-[20px] border-t-[1.5px] border-x-[1.5px] border-[#1B1C1A] px-6 pt-5 pb-6 max-h-[88%]" style={{ shadowColor: C.ink, shadowOpacity: 0.14, elevation: 3, shadowRadius: 0, shadowOffset: { width: 0, height: -4 } }}>
            <View className="absolute -top-2 left-1/2 -translate-x-1/2 z-10">
              <WashiTape w={56} rotate="-2deg" color={color} />
            </View>
            <View className="w-10 h-1.5 rounded-full bg-[#1B1C1A] opacity-20 self-center mb-4" />

            <View className="flex-row items-center justify-between">
              <View className="flex-row items-center gap-2">
                <View className="w-8 h-8 rounded-full border border-[#1B1C1A] items-center justify-center" style={{ backgroundColor: color }}>
                  <Camera size={14} color={C.ink} strokeWidth={1.8} />
                </View>
                <View>
                  <Text className="text-[16px] font-extrabold text-[#1B1C1A]" style={{ fontFamily: "Bricolage Grotesque" }}>
                    Tambah foto baru
                  </Text>
                  <Text className="text-[11px] text-[#837377]" style={{ fontFamily: "Space Mono" }}>
                    Nempel polaroid baru ke jurnal
                  </Text>
                </View>
              </View>
              <Pressable onPress={() => setShowAdd(false)} className="w-8 h-8 rounded-full bg-white border border-[#1B1C1A] items-center justify-center">
                <X size={16} color={C.ink} strokeWidth={2} />
              </Pressable>
            </View>

            <ScrollView showsVerticalScrollIndicator={false} className="mt-5" contentContainerClassName="gap-4 pb-2">
              {/* polaroid preview - signature */}
              <View className="bg-white rounded-[14px] border-[1.5px] border-[#1B1C1A] p-3" style={{ shadowColor: C.ink, shadowOpacity: 0.08, shadowRadius: 0, shadowOffset: { width: 2, height: 2 }, transform: [{ rotate: "-0.5deg" }] }}>
                <View className="h-[132px] rounded-[12px] border border-black/5 items-center justify-center gap-2" style={{ backgroundColor: color }}>
                  <View className="w-16 h-16 rounded-[10px] bg-white border border-[#1B1C1A] items-center justify-center">
                    <Images size={20} color={C.ink} strokeWidth={1.6} />
                  </View>
                  <Text className="text-[10px] font-bold tracking-[0.8px] text-[#1B1C1A]" style={{ fontFamily: "Space Mono" }}>
                    PREVIEW POLAROID
                  </Text>
                </View>
                <View className="mt-2 flex-row items-center gap-1.5">
                  <View className="w-1.5 h-1.5 rounded-full bg-[#864D61]" />
                  <Text className="text-[11px] text-[#837377]" style={{ fontFamily: "Space Mono" }}>
                    Foto akan ditempel dengan tape {COLORS.find((c) => c.hex === color)?.label.toLowerCase()}
                  </Text>
                </View>
              </View>

              {/* siapa yang upload */}
              <View className="gap-2">
                <Text className="text-[11px] font-bold tracking-[0.7px] text-[#837377]" style={{ fontFamily: "Space Mono" }}>
                  DIUNGGAH OLEH
                </Text>
                <View className="flex-row gap-2">
                  {(["Alya", "Bima", "Kita"] as const).map((a) => (
                    <Pressable key={a} onPress={() => setAuthor(a)} className="flex-1 rounded-full border py-2 items-center" style={{ backgroundColor: author === a ? C.ink : "#fff", borderColor: C.ink, borderWidth: 1.4 }}>
                      <Text className="text-[12px] font-bold" style={{ fontFamily: "Space Mono", color: author === a ? "#fff" : C.ink }}>
                        {a.toUpperCase()}
                      </Text>
                    </Pressable>
                  ))}
                </View>
              </View>

              {/* judul */}
              <View className="gap-1.5">
                <View className="flex-row items-center gap-1.5">
                  <PenLine size={13} color={errors.title ? C.error : "#837377"} />
                  <Text className="text-[11px] font-bold tracking-[0.7px]" style={{ fontFamily: "Space Mono", color: errors.title ? C.error : "#837377" }}>
                    JUDUL FOTO
                  </Text>
                  {errors.title && <View className="w-1 h-1 rounded-full bg-[#ba1a1a]" />}
                </View>
                <View className="flex-row items-end gap-2 border-b-[1.6px] pb-2 pt-1" style={{ borderColor: errors.title ? C.error : C.ink }}>
                  <TextInput
                    value={title}
                    onChangeText={(v) => { setTitle(v); if (errors.title) setErrors((p) => ({ ...p, title: undefined })); }}
                    placeholder="Contoh: Sore di pantai jam 5"
                    placeholderTextColor="#B8A9AC"
                    className="flex-1 text-[15px] p-0"
                    style={{ fontFamily: "Bricolage Grotesque", paddingVertical: 0, color: errors.title ? C.error : C.ink }}
                  />
                  <View className="w-[18px] h-[1.5px] rounded-full mb-1.5" style={{ backgroundColor: errors.title ? C.error : C.ink, opacity: errors.title ? 1 : 0.3 }} />
                </View>
                {errors.title && (
                  <View className="flex-row items-start gap-1.5 rounded-[8px] border px-2.5 py-1.5" style={{ backgroundColor: C.errorBg, borderColor: "#E8B4B0" }}>
                    <Text className="flex-1 text-[11px] leading-[14px]" style={{ fontFamily: "Space Mono", color: "#93000a" }}>
                      {errors.title}
                    </Text>
                  </View>
                )}
              </View>

              {/* cerita */}
              <View className="gap-1.5">
                <View className="flex-row items-center gap-1.5">
                  <Images size={13} color={errors.caption ? C.error : "#837377"} />
                  <Text className="text-[11px] font-bold tracking-[0.7px]" style={{ fontFamily: "Space Mono", color: errors.caption ? C.error : "#837377" }}>
                    CERITA SINGKAT
                  </Text>
                  {errors.caption && <View className="w-1 h-1 rounded-full bg-[#ba1a1a]" />}
                </View>
                <View className="bg-white rounded-[12px] border-[1.4px] p-3" style={{ borderColor: errors.caption ? C.error : C.ink }}>
                  <TextInput
                    value={caption}
                    onChangeText={(v) => { setCaption(v); if (errors.caption) setErrors((p) => ({ ...p, caption: undefined })); }}
                    placeholder="Ceritakan momen ini dalam 1-2 kalimat..."
                    placeholderTextColor="#B8A9AC"
                    multiline
                    numberOfLines={3}
                    textAlignVertical="top"
                    className="min-h-[72px] text-[14px] leading-5 p-0"
                    style={{ fontFamily: "Plus Jakarta Sans", color: C.ink }}
                  />
                  <View className="gap-2 mt-2">
                    <View className="h-[1px] bg-[#1B1C1A] opacity-[0.06]" />
                    <View className="h-[1px] bg-[#1B1C1A] opacity-[0.06]" />
                  </View>
                </View>
                {errors.caption ? (
                  <View className="flex-row items-start gap-1.5 rounded-[8px] border px-2.5 py-1.5" style={{ backgroundColor: C.errorBg, borderColor: "#E8B4B0" }}>
                    <Text className="flex-1 text-[11px] leading-[14px]" style={{ fontFamily: "Space Mono", color: "#93000a" }}>
                      {errors.caption}
                    </Text>
                  </View>
                ) : (
                  <Text className="text-[11px] text-[#837377]" style={{ fontFamily: "Space Mono" }}>
                    {caption.length}/120 • akan jadi caption polaroid
                  </Text>
                )}
              </View>

              {/* warna tape */}
              <View className="gap-2">
                <Text className="text-[11px] font-bold tracking-[0.7px] text-[#837377]" style={{ fontFamily: "Space Mono" }}>
                  WARNA TAPE
                </Text>
                <View className="flex-row gap-2.5">
                  {COLORS.map((c) => (
                    <Pressable key={c.hex} onPress={() => setColor(c.hex)} className="w-12 h-12 rounded-full border-[1.6px] items-center justify-center" style={{ backgroundColor: c.hex, borderColor: color === c.hex ? C.ink : "#D5C2C6", transform: [{ scale: color === c.hex ? 1.08 : 1 }, { rotate: color === c.hex ? "-2deg" : "0deg" }] }}>
                      {color === c.hex && <Check size={16} color={C.ink} strokeWidth={2.5} />}
                    </Pressable>
                  ))}
                  <View className="flex-1 bg-[#FDFCF8] border border-dashed border-[#1B1C1A] rounded-full items-center justify-center px-2">
                    <Text className="text-[10px] font-bold text-[#837377] text-center" style={{ fontFamily: "Space Mono" }}>
                      {COLORS.find((x) => x.hex === color)?.label}
                    </Text>
                  </View>
                </View>
              </View>

              <Pressable onPress={handleSave} className="mt-1 bg-[#864D61] rounded-full border-[1.6px] border-[#1B1C1A] py-3.5 flex-row items-center justify-center gap-2 active:opacity-90" style={{ shadowColor: C.ink, shadowOpacity: 0.14, elevation: 3, shadowRadius: 0, shadowOffset: { width: 3, height: 3 } }}>
                <Text className="text-[15px] font-extrabold text-white" style={{ fontFamily: "Bricolage Grotesque" }}>
                  Tempel ke jurnal
                </Text>
                <View className="w-6 h-6 rounded-full bg-white items-center justify-center">
                  <Camera size={12} color={C.ink} strokeWidth={2} />
                </View>
              </Pressable>
              <Text className="text-center text-[11px] text-[#837377]" style={{ fontFamily: "Space Mono" }}>
                Akan ditempel paling atas dengan rotasi acak
              </Text>
            </ScrollView>
          </View>
        </View>
      </Modal>
    </View>
  );
}
