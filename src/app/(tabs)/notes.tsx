import { useState } from "react";
import { View, Text, ScrollView, Pressable, Modal, TextInput } from "react-native";
import { StickyNote, PenLine, Heart, Search, Plus, X, Check } from "lucide-react-native";
import { WashiTape } from "@/components/ui/washi-tape";

const C = { ink: "#1B1C1A", pink: "#FFD9E3", yellow: "#EEE199", blue: "#B4EBFF", mint: "#C6F0D1", error: "#ba1a1a", errorBg: "#ffdad6" };

type Note = { id: number; title: string; date: string; author: string; color: string; rot: string; excerpt: string };

const INITIAL: Note[] = [
  { id: 1, title: "Surat untukmu — kalau kangen", date: "30 AUG", author: "Alya", color: "#FFD9E3", rot: "-0.7deg", excerpt: "Hari ini aku masak sup pertama kali, gagal keasinan tapi kamu bilang enak..." },
  { id: 2, title: "Ide kencan minggu depan", date: "27 AUG", author: "Bima", color: "#C6F0D1", rot: "0.6deg", excerpt: "• piknik di taman • nonton film studio • masak bareng lagi (yang bener)" },
  { id: 3, title: "Do & don’t kalau berantem", date: "20 AUG", author: "Kita", color: "#EEE199", rot: "-0.4deg", excerpt: "Dengerin dulu, jangan potong. Kasih jeda 10 menit kalau emosi." },
];

const COLORS = [
  { hex: "#FFD9E3", label: "PINK" },
  { hex: "#C6F0D1", label: "MINT" },
  { hex: "#EEE199", label: "KUNING" },
  { hex: "#B4EBFF", label: "BIRU" },
];

export default function NotesTab() {
  const [notes, setNotes] = useState<Note[]>(INITIAL);
  const [showAdd, setShowAdd] = useState(false);
  const [title, setTitle] = useState("");
  const [body, setBody] = useState("");
  const [color, setColor] = useState(C.pink);
  const [author, setAuthor] = useState<"Alya" | "Bima" | "Kita">("Alya");
  const [errors, setErrors] = useState<{ title?: string; body?: string }>({});
  const [q, setQ] = useState("");

  const filtered = notes.filter((n) => !q || n.title.toLowerCase().includes(q.toLowerCase()) || n.excerpt.toLowerCase().includes(q.toLowerCase()));

  const handleSave = () => {
    const next: typeof errors = {};
    if (!title.trim()) next.title = "Judul wajib diisi — kasih nama untuk catatanmu.";
    else if (title.trim().length < 3) next.title = "Minimal 3 karakter.";
    if (!body.trim()) next.body = "Isi catatan wajib diisi.";
    else if (body.trim().length < 8) next.body = "Tulis sedikit lebih panjang, minimal 8 karakter.";
    setErrors(next);
    if (Object.keys(next).length) return;

    const now = new Date();
    const date = `${String(now.getDate()).padStart(2, "0")} ${now.toLocaleString("en-US", { month: "short" }).toUpperCase()}`;
    const newNote: Note = {
      id: Date.now(),
      title: title.trim(),
      date,
      author,
      color,
      rot: `${(Math.random() * 1.2 - 0.6).toFixed(1)}deg`,
      excerpt: body.trim().slice(0, 90),
    };
    setNotes((prev) => [newNote, ...prev]);
    setTitle("");
    setBody("");
    setErrors({});
    setShowAdd(false);
  };

  return (
    <View className="flex-1 bg-[#FDFCF8] overflow-hidden">
      <View pointerEvents="none" className="absolute inset-0 overflow-hidden">
        <View className="absolute -top-10 -right-10 w-48 h-48 rounded-full bg-[#C6F0D1] opacity-20" />
        <View className="absolute top-[280px] -left-10 w-40 h-40 rounded-full bg-[#FFD9E3] opacity-15" />
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
          <View className="flex-row items-center gap-2">
            <View className="w-2 h-2 rounded-full bg-[#864D61]" />
            <Text className="text-[11px] font-bold tracking-[1px] text-[#864D61]" style={{ fontFamily: "Space Mono" }}>
              RUANG KITA • CATATAN
            </Text>
          </View>
          <Text className="mt-1.5 text-[28px] font-extrabold leading-[30px] tracking-[-1px] text-[#1B1C1A]" style={{ fontFamily: "Bricolage Grotesque" }}>
            Catatan <Text className="text-[#837377] font-light">kecil</Text>
          </Text>
          <Text className="mt-1.5 text-[13px] leading-5 text-[#514347]" style={{ fontFamily: "Plus Jakarta Sans" }}>
            Surat, ide, dan janji kecil — kayak sticky notes yang ditempel di kulkas.
          </Text>

          <View className="mt-4 flex-row items-center gap-2">
            <View className="flex-1 flex-row items-center gap-2 bg-white border border-[#1B1C1A] rounded-full px-3 py-2" style={{ shadowColor: C.ink, shadowOpacity: 1, shadowRadius: 0, shadowOffset: { width: 2, height: 2 } }}>
              <Search size={14} color="#837377" />
              <TextInput
                value={q}
                onChangeText={setQ}
                placeholder="Cari catatan..."
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
            <Pressable onPress={() => { setErrors({}); setShowAdd(true); }} className="w-[42px] h-[42px] rounded-full bg-[#864D61] border border-[#1B1C1A] items-center justify-center active:scale-95" style={{ shadowColor: C.ink, shadowOpacity: 1, shadowRadius: 0, shadowOffset: { width: 2, height: 2 } }}>
              <Plus size={18} color="#fff" strokeWidth={2.2} />
            </Pressable>
          </View>

          {/* empty state */}
          {filtered.length === 0 ? (
            <View className="mt-8 bg-white rounded-[16px] border-[1.5px] border-[#1B1C1A] border-dashed p-6 items-center" style={{ transform: [{ rotate: "-0.3deg" }] }}>
              <View className="w-10 h-10 rounded-full bg-[#FDFCF8] border border-[#1B1C1A] items-center justify-center">
                <StickyNote size={18} color={C.ink} />
              </View>
              <Text className="mt-3 text-[14px] font-bold text-[#1B1C1A]" style={{ fontFamily: "Bricolage Grotesque" }}>
                Belum ada catatan
              </Text>
              <Text className="text-[12px] text-[#837377] text-center mt-1" style={{ fontFamily: "Space Mono" }}>
                {q ? `Tidak ada hasil untuk "${q}"` : "Tap + untuk tulis sticky note pertamamu."}
              </Text>
            </View>
          ) : (
            <View className="mt-5 gap-4">
              {filtered.map((n) => (
                <View key={n.id} className="bg-white rounded-[16px] border-[1.5px] border-[#1B1C1A] p-3.5 overflow-visible" style={{ shadowColor: C.ink, shadowOpacity: 1, shadowRadius: 0, shadowOffset: { width: 3, height: 3 }, transform: [{ rotate: n.rot }], overflow: "visible" as any }}>
                  <View className="absolute -top-1.5 left-4 z-10">
                    <WashiTape w={36} rotate="-3deg" color={n.color} />
                  </View>
                  <View className="flex-row items-center gap-2">
                    <View className="w-7 h-7 rounded-full border border-[#1B1C1A] items-center justify-center" style={{ backgroundColor: n.color }}>
                      <StickyNote size={13} color={C.ink} strokeWidth={1.8} />
                    </View>
                    <Text className="text-[11px] font-bold tracking-[0.6px] text-[#837377]" style={{ fontFamily: "Space Mono" }}>
                      {n.date} • {n.author.toUpperCase()}
                    </Text>
                    <View className="ml-auto w-6 h-6 rounded-full bg-[#FDFCF8] border border-black/5 items-center justify-center">
                      <Heart size={10} color="#864D61" fill={C.pink} />
                    </View>
                  </View>
                  <Text className="mt-2.5 text-[15px] font-bold leading-[18px] text-[#1B1C1A]" style={{ fontFamily: "Bricolage Grotesque" }}>
                    {n.title}
                  </Text>
                  <View className="mt-2 bg-[#FDFCF8] rounded-[10px] border border-black/5 p-2.5">
                    <Text className="text-[12px] leading-[18px] text-[#514347]" style={{ fontFamily: "Plus Jakarta Sans" }} numberOfLines={2}>
                      {n.excerpt}
                    </Text>
                  </View>
                  <View className="mt-2.5 flex-row items-center gap-1.5">
                    <PenLine size={12} color="#837377" />
                    <Text className="text-[11px] text-[#837377]" style={{ fontFamily: "Space Mono" }}>
                      Tap untuk baca & balas
                    </Text>
                  </View>
                </View>
              ))}
            </View>
          )}

          <View className="mt-5 flex-row items-center gap-2">
            <View className="flex-1 h-[1px] bg-[#D5C2C6] opacity-30" />
            <Text className="text-[11px] italic text-[#837377]" style={{ fontFamily: "Bricolage Grotesque" }}>
              tulis sesuatu hari ini
            </Text>
            <Heart size={10} color="#864D61" fill="#FFB7CE" />
            <View className="flex-1 h-[1px] bg-[#D5C2C6] opacity-30" />
          </View>
        </View>
      </ScrollView>

      {/* Add Notes Sheet - signature: sticky note composer */}
      <Modal visible={showAdd} animationType="slide" transparent onRequestClose={() => { setErrors({}); setShowAdd(false); }} statusBarTranslucent>
        <View className="flex-1 bg-[#1B1C1A]/40 justify-end">
          <Pressable className="flex-1" onPress={() => setShowAdd(false)} />
          <View className="bg-[#FDFCF8] rounded-t-[20px] border-t-[1.5px] border-x-[1.5px] border-[#1B1C1A] px-6 pt-5 pb-6 max-h-[86%]" style={{ shadowColor: C.ink, shadowOpacity: 1, shadowRadius: 0, shadowOffset: { width: 0, height: -4 } }}>
            {/* washi top */}
            <View className="absolute -top-2 left-1/2 -translate-x-1/2 z-10">
              <WashiTape w={56} rotate="-2deg" color={color} />
            </View>
            <View className="w-10 h-1.5 rounded-full bg-[#1B1C1A] opacity-20 self-center mb-4" />

            <View className="flex-row items-center justify-between">
              <View className="flex-row items-center gap-2">
                <View className="w-8 h-8 rounded-full border border-[#1B1C1A] items-center justify-center" style={{ backgroundColor: color }}>
                  <StickyNote size={14} color={C.ink} strokeWidth={1.8} />
                </View>
                <View>
                  <Text className="text-[16px] font-extrabold text-[#1B1C1A]" style={{ fontFamily: "Bricolage Grotesque" }}>
                    Tulis catatan baru
                  </Text>
                  <Text className="text-[11px] text-[#837377]" style={{ fontFamily: "Space Mono" }}>
                    Kayak nempel sticky note di kulkas
                  </Text>
                </View>
              </View>
              <Pressable onPress={() => setShowAdd(false)} className="w-8 h-8 rounded-full bg-white border border-[#1B1C1A] items-center justify-center">
                <X size={16} color={C.ink} strokeWidth={2} />
              </Pressable>
            </View>

            <ScrollView showsVerticalScrollIndicator={false} className="mt-5" contentContainerClassName="gap-4 pb-2">
              {/* penulis */}
              <View className="gap-2">
                <Text className="text-[11px] font-bold tracking-[0.7px] text-[#837377]" style={{ fontFamily: "Space Mono" }}>
                  DITULIS SEBAGAI
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

              {/* judul - ruled notebook line */}
              <View className="gap-1.5">
                <View className="flex-row items-center gap-1.5">
                  <PenLine size={13} color={errors.title ? C.error : "#837377"} />
                  <Text className="text-[11px] font-bold tracking-[0.7px]" style={{ fontFamily: "Space Mono", color: errors.title ? C.error : "#837377" }}>
                    JUDUL
                  </Text>
                  {errors.title && <View className="w-1 h-1 rounded-full bg-[#ba1a1a]" />}
                </View>
                <View className="flex-row items-end gap-2 border-b-[1.6px] pb-2 pt-1" style={{ borderColor: errors.title ? C.error : C.ink }}>
                  <TextInput
                    value={title}
                    onChangeText={(v) => { setTitle(v); if (errors.title) setErrors((p) => ({ ...p, title: undefined })); }}
                    placeholder="Contoh: Surat untukmu kalau kangen"
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

              {/* isi - ruled multi line */}
              <View className="gap-1.5">
                <View className="flex-row items-center gap-1.5">
                  <StickyNote size={13} color={errors.body ? C.error : "#837377"} />
                  <Text className="text-[11px] font-bold tracking-[0.7px]" style={{ fontFamily: "Space Mono", color: errors.body ? C.error : "#837377" }}>
                    ISI CATATAN
                  </Text>
                  {errors.body && <View className="w-1 h-1 rounded-full bg-[#ba1a1a]" />}
                </View>
                <View className="bg-white rounded-[12px] border-[1.4px] p-3" style={{ borderColor: errors.body ? C.error : C.ink, shadowColor: C.ink, shadowOpacity: 0.06, shadowRadius: 0, shadowOffset: { width: 2, height: 2 } }}>
                  <TextInput
                    value={body}
                    onChangeText={(v) => { setBody(v); if (errors.body) setErrors((p) => ({ ...p, body: undefined })); }}
                    placeholder="Tulis isi hati, ide kencan, atau janji kecil..."
                    placeholderTextColor="#B8A9AC"
                    multiline
                    numberOfLines={4}
                    textAlignVertical="top"
                    className="min-h-[96px] text-[14px] leading-5 p-0"
                    style={{ fontFamily: "Plus Jakarta Sans", color: C.ink }}
                  />
                  {/* ruled lines visual */}
                  <View className="gap-2 mt-2">
                    <View className="h-[1px] bg-[#1B1C1A] opacity-[0.06]" />
                    <View className="h-[1px] bg-[#1B1C1A] opacity-[0.06]" />
                    <View className="h-[1px] bg-[#1B1C1A] opacity-[0.06]" />
                  </View>
                </View>
                {errors.body ? (
                  <View className="flex-row items-start gap-1.5 rounded-[8px] border px-2.5 py-1.5" style={{ backgroundColor: C.errorBg, borderColor: "#E8B4B0" }}>
                    <Text className="flex-1 text-[11px] leading-[14px]" style={{ fontFamily: "Space Mono", color: "#93000a" }}>
                      {errors.body}
                    </Text>
                  </View>
                ) : (
                  <Text className="text-[11px] text-[#837377]" style={{ fontFamily: "Space Mono" }}>
                    {body.length}/240 • akan tampil sebagai sticky note
                  </Text>
                )}
              </View>

              {/* warna kertas */}
              <View className="gap-2">
                <Text className="text-[11px] font-bold tracking-[0.7px] text-[#837377]" style={{ fontFamily: "Space Mono" }}>
                  WARNA KERTAS
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

              <Pressable onPress={handleSave} className="mt-1 bg-[#864D61] rounded-full border-[1.6px] border-[#1B1C1A] py-3.5 flex-row items-center justify-center gap-2 active:scale-[0.98]" style={{ shadowColor: C.ink, shadowOpacity: 1, shadowRadius: 0, shadowOffset: { width: 3, height: 3 } }}>
                <Text className="text-[15px] font-extrabold text-white" style={{ fontFamily: "Bricolage Grotesque" }}>
                  Tempel catatan
                </Text>
                <View className="w-6 h-6 rounded-full bg-white items-center justify-center">
                  <StickyNote size={12} color={C.ink} strokeWidth={2} />
                </View>
              </Pressable>
              <Text className="text-center text-[11px] text-[#837377]" style={{ fontFamily: "Space Mono" }}>
                Akan muncul paling atas dengan washi tape {COLORS.find((x) => x.hex === color)?.label.toLowerCase()}
              </Text>
            </ScrollView>
          </View>
        </View>
      </Modal>
    </View>
  );
}
