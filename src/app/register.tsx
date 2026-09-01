import { useState } from "react";
import { View, Text, Pressable, ScrollView, TextInput } from "react-native";
import { Link, useRouter } from "expo-router";
import { ArrowLeft, Lock, Mail, User, Link2, Heart, AlertCircle } from "lucide-react-native";
import { WashiTape } from "@/components/ui/washi-tape";
import { SwipeButton } from "@/components/ui/swipe-button";
import { NotebookInput } from "@/components/ui/notebook-input";

const C = {
  ink: "#1B1C1A",
  primary: "#864D61",
  pink: "#FFB7CE",
  yellow: "#EEE199",
  blueSoft: "#B4EBFF",
  outlineStrong: "#837377",
  error: "#ba1a1a",
  errorContainer: "#ffdad6",
  onErrorContainer: "#93000a",
};

const emailRx = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
const codeRx = /^OUR-[A-Z0-9]{4}$/;

export default function RegisterPage() {
  const router = useRouter();
  const [name, setName] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [partnerCode, setPartnerCode] = useState("");
  const [errors, setErrors] = useState<{ name?: string; email?: string; password?: string; partnerCode?: string }>({});
  const [touched, setTouched] = useState({ name: false, email: false, password: false, partnerCode: false });

  const validate = (n = name, e = email, p = password, pc = partnerCode) => {
    const next: typeof errors = {};
    if (!n.trim()) next.name = "Nama panggilan wajib diisi.";
    else if (n.trim().length < 2) next.name = "Minimal 2 karakter.";
    if (!e.trim()) next.email = "Email wajib diisi.";
    else if (!emailRx.test(e.trim())) next.email = "Format email tidak valid — contoh: kamu@email.com";
    if (!p) next.password = "Kata sandi wajib diisi.";
    else if (p.length < 8) next.password = "Minimal 8 karakter — biar aman.";
    if (pc.trim() && !codeRx.test(pc.trim().toUpperCase())) next.partnerCode = "Format kode harus OUR-XXXX (contoh: OUR-A1B2).";
    return next;
  };

  const handleSwipe = () => {
    const next = validate();
    setErrors(next);
    setTouched({ name: true, email: true, password: true, partnerCode: true });
    if (Object.keys(next).length) return;
    router.replace("/(tabs)/home");
  };

  const hasError = Object.keys(errors).length > 0 && Object.values(touched).some(Boolean);

  return (
    <View className="flex-1 bg-[#FDFCF8] overflow-hidden">
      <View pointerEvents="none" className="absolute inset-0 overflow-hidden">
        <View className="absolute -top-20 -right-16 w-[260px] h-[260px] rounded-full bg-[#FFD9E3] opacity-[0.24]" />
        <View className="absolute top-[320px] -left-16 w-[200px] h-[200px] rounded-full bg-[#B4EBFF] opacity-[0.18]" />
        <View className="absolute bottom-16 right-8 w-28 h-28 rounded-full bg-[#EEE199] opacity-[0.16]" />
        <Text numberOfLines={1} className="absolute left-0 right-0 text-center text-[180px] font-extrabold text-[#1B1C1A] opacity-[0.025] top-[48%] -translate-y-1/2" style={{ fontFamily: "Bricolage Grotesque" }}>
          03
        </Text>
      </View>

      <ScrollView
        showsVerticalScrollIndicator={false}
        showsHorizontalScrollIndicator={false}
        horizontal={false}
        bounces={false}
        overScrollMode="never"
        keyboardShouldPersistTaps="handled"
        contentContainerStyle={{ flexGrow: 1 }}
        contentContainerClassName="grow px-6 pt-12 pb-6"
      >
        <View className="w-full max-w-[400px] self-center flex-1">
          <View className="flex-row items-center justify-between">
            <Link href="/" asChild>
              <Pressable className="w-9 h-9 rounded-full bg-white border border-[#1B1C1A] items-center justify-center active:opacity-80" style={{ shadowColor: C.ink, shadowOpacity: 1, shadowRadius: 0, shadowOffset: { width: 2, height: 2 } }}>
                <ArrowLeft size={16} color={C.ink} strokeWidth={2.2} />
              </Pressable>
            </Link>
            <View className="flex-row items-center gap-2">
              <View className="w-2 h-2 rounded-full bg-[#864D61]" />
              <Text className="text-[10px] font-bold tracking-[1.4px] text-[#837377]" style={{ fontFamily: "Space Mono" }}>
                OURSPACE
              </Text>
            </View>
            <Text className="text-[11px] text-[#837377]" style={{ fontFamily: "Space Mono" }}>
              03 / 03
            </Text>
          </View>

          <View className="mt-7">
            <Text className="text-[34px] font-extrabold leading-[36px] tracking-[-1.2px] text-[#1B1C1A]" style={{ fontFamily: "Bricolage Grotesque" }}>
              Buat ruang{"\n"}
              <Text className="text-[#864D61]">kalian.</Text>
            </Text>
            <View className="mt-2 flex-row items-center gap-2">
              <View className="w-[120px] h-[7px] bg-[#93D4EB] rounded-full opacity-80" style={{ transform: [{ rotate: "-0.6deg" }] }} />
              <Text className="text-[11px] text-[#837377] italic" style={{ fontFamily: "Bricolage Grotesque" }}>
                — 30 detik jadi
              </Text>
            </View>
            <Text className="mt-2.5 text-[14.5px] leading-6 text-[#514347]" style={{ fontFamily: "Plus Jakarta Sans" }}>
              Satu ruang privat untuk berdua. Nanti bisa undang pasangan pakai kode.
            </Text>
          </View>

          {hasError && (
            <View className="mt-4 flex-row items-start gap-2.5 rounded-[12px] border-[1.4px] border-[#ba1a1a] px-3.5 py-3" style={{ backgroundColor: C.errorContainer, shadowColor: C.ink, shadowOpacity: 1, shadowRadius: 0, shadowOffset: { width: 3, height: 3 } }}>
              <View className="w-7 h-7 rounded-full bg-[#ba1a1a] items-center justify-center mt-0.5">
                <AlertCircle size={14} color="#fff" strokeWidth={2.2} />
              </View>
              <View className="flex-1">
                <Text className="text-[13px] font-bold" style={{ fontFamily: "Bricolage Grotesque", color: C.onErrorContainer }}>
                  Cek lagi isianmu
                </Text>
                <Text className="text-[12px] leading-4 mt-0.5" style={{ fontFamily: "Plus Jakarta Sans", color: C.onErrorContainer }}>
                  Ada {Object.keys(errors).length} isian perlu dibetulkan — lihat tanda merah di bawah.
                </Text>
              </View>
            </View>
          )}

          <View className="mt-5 bg-white rounded-[20px] border-[1.5px] p-5 pt-6" style={{ borderColor: hasError ? C.error : C.ink, shadowColor: C.ink, shadowOpacity: 1, shadowRadius: 0, shadowOffset: { width: 4, height: 4 } }}>
            <View className="absolute -top-2 left-7 z-10">
              <WashiTape w={56} rotate="-3deg" color={hasError ? C.errorContainer : C.yellow} />
            </View>
            <View className="absolute -top-2 right-8 z-10">
              <WashiTape w={44} rotate="4deg" color={C.blueSoft} />
            </View>

            <View className="gap-5">
              <NotebookInput label="NAMA PANGGILAN" value={name} onChangeText={(v) => { setName(v); if (touched.name) setErrors((p) => ({ ...p, name: validate(v, email, password, partnerCode).name })); }} placeholder="Panggil aku..." icon={User} autoCapitalize="words" error={touched.name ? errors.name : undefined} onBlur={() => setTouched((s) => ({ ...s, name: true }))} />
              <NotebookInput label="EMAIL" value={email} onChangeText={(v) => { setEmail(v); if (touched.email) setErrors((p) => ({ ...p, email: validate(name, v, password, partnerCode).email })); }} placeholder="kamu@email.com" icon={Mail} keyboardType="email-address" error={touched.email ? errors.email : undefined} onBlur={() => setTouched((s) => ({ ...s, email: true }))} />
              <NotebookInput label="KATA SANDI" value={password} onChangeText={(v) => { setPassword(v); if (touched.password) setErrors((p) => ({ ...p, password: validate(name, email, v, partnerCode).password })); }} placeholder="Minimal 8 karakter" icon={Lock} secure error={touched.password ? errors.password : undefined} onBlur={() => setTouched((s) => ({ ...s, password: true }))} />

              <View className="gap-1.5">
                <View className="flex-row items-center gap-1.5">
                  <Link2 size={13} color={errors.partnerCode && touched.partnerCode ? C.error : C.outlineStrong} strokeWidth={2} />
                  <Text className="text-[11px] font-bold tracking-[0.8px]" style={{ fontFamily: "Space Mono", color: errors.partnerCode && touched.partnerCode ? C.error : "#837377" }}>
                    KODE PASANGAN <Text className="font-normal normal-case tracking-[0px]">(opsional)</Text>
                  </Text>
                  {errors.partnerCode && touched.partnerCode && <View className="w-1 h-1 rounded-full bg-[#ba1a1a] ml-0.5" />}
                </View>
                <View className="flex-row items-end gap-2 border-b-[1.6px] pb-2 pt-1" style={{ borderColor: errors.partnerCode && touched.partnerCode ? C.error : C.ink, borderStyle: partnerCode ? "solid" : "dashed" }}>
                  <TextInput
                    value={partnerCode}
                    onChangeText={(v) => { setPartnerCode(v.toUpperCase()); if (touched.partnerCode) setErrors((p) => ({ ...p, partnerCode: validate(name, email, password, v).partnerCode })); }}
                    onBlur={() => setTouched((s) => ({ ...s, partnerCode: true }))}
                    placeholder="OUR-XXXX"
                    placeholderTextColor="#B8A9AC"
                    autoCapitalize="characters"
                    className="flex-1 text-[15px] p-0 tracking-[0.6px]"
                    style={{ fontFamily: "Space Mono", paddingVertical: 0, color: errors.partnerCode && touched.partnerCode ? C.error : C.ink }}
                  />
                  <View className="bg-[#FDFCF8] border border-[#D5C2C6] rounded-full px-2 py-1">
                    <Text className="text-[10px] font-bold text-[#837377]" style={{ fontFamily: "Space Mono" }}>
                      LEWATI
                    </Text>
                  </View>
                </View>
                {touched.partnerCode && errors.partnerCode ? (
                  <View className="flex-row items-start gap-1.5 rounded-[8px] border px-2.5 py-1.5" style={{ backgroundColor: C.errorContainer, borderColor: "#E8B4B0" }}>
                    <AlertCircle size={13} color={C.error} strokeWidth={2} style={{ marginTop: 1 }} />
                    <Text className="flex-1 text-[11px] leading-[14px]" style={{ fontFamily: "Space Mono", color: C.onErrorContainer }}>
                      {errors.partnerCode}
                    </Text>
                  </View>
                ) : (
                  <Text className="text-[11px] leading-4 text-[#837377]" style={{ fontFamily: "Plus Jakarta Sans" }}>
                    Kosongkan dulu nggak apa-apa — bisa undang nanti dari dalam ruang.
                  </Text>
                )}
              </View>
            </View>

            <View className="mt-5 flex-row flex-wrap gap-2">
              <View className="bg-[#1B1C1A] rounded-full px-2.5 py-1">
                <Text className="text-[10px] font-bold text-white tracking-[0.3px]" style={{ fontFamily: "Space Mono" }}>
                  PRIVAT
                </Text>
              </View>
              <View className="bg-[#EEE199] border border-[#1B1C1A] rounded-full px-2.5 py-1">
                <Text className="text-[10px] font-bold text-[#1B1C1A]" style={{ fontFamily: "Space Mono" }}>
                  TANPA IKLAN
                </Text>
              </View>
              <View className="bg-white border border-[#D5C2C6] rounded-full px-2.5 py-1">
                <Text className="text-[10px] font-bold text-[#837377]" style={{ fontFamily: "Space Mono" }}>
                  HAPUS KAPAN SAJA
                </Text>
              </View>
            </View>
          </View>

          <Text className="mt-3 text-center text-[11px] leading-4 text-[#837377] px-2" style={{ fontFamily: "Plus Jakarta Sans" }}>
            Dengan mendaftar, kamu setuju ruang ini privat & aman — hanya kalian berdua yang bisa lihat.
          </Text>

          <View className="flex-1 min-h-[12px]" />

          <View className="mt-5 gap-3">
            <SwipeButton label="Geser untuk daftar" onComplete={handleSwipe} hint="GESER UNTUK MEMBUAT RUANG" />
            <View className="flex-row items-center justify-center gap-1.5 py-1">
              <Text className="text-[13px] text-[#514347]" style={{ fontFamily: "Space Mono" }}>
                Sudah punya ruang?
              </Text>
              <Link href="/login" asChild>
                <Pressable>
                  <Text className="text-[13px] font-bold text-[#1B1C1A] underline" style={{ fontFamily: "Space Mono" }}>
                    Masuk
                  </Text>
                </Pressable>
              </Link>
              <Heart size={12} color={C.primary} fill={C.pink} strokeWidth={1.6} />
            </View>
          </View>
        </View>
      </ScrollView>
    </View>
  );
}
