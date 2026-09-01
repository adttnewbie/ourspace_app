import { useState } from "react";
import { View, Text, Pressable, ScrollView } from "react-native";
import { useSafeAreaInsets } from "react-native-safe-area-context";
import { Link, useRouter } from "expo-router";
import { ArrowLeft, Lock, Mail, Heart, AlertCircle } from "lucide-react-native";
import { WashiTape } from "@/components/ui/washi-tape";
import { SwipeButton } from "@/components/ui/swipe-button";
import { NotebookInput } from "@/components/ui/notebook-input";

const C = {
  ink: "#1B1C1A",
  muted: "#514347",
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

export default function LoginPage() {
  const insets = useSafeAreaInsets();
  const router = useRouter();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [errors, setErrors] = useState<{ email?: string; password?: string }>({});
  const [touched, setTouched] = useState<{ email: boolean; password: boolean }>({ email: false, password: false });

  const validate = (e = email, p = password) => {
    const next: typeof errors = {};
    if (!e.trim()) next.email = "Email wajib diisi.";
    else if (!emailRx.test(e.trim())) next.email = "Format email tidak valid — contoh: kamu@email.com";
    if (!p) next.password = "Kata sandi wajib diisi.";
    else if (p.length < 6) next.password = "Minimal 6 karakter.";
    return next;
  };

  const handleSwipe = () => {
    const next = validate();
    setErrors(next);
    setTouched({ email: true, password: true });
    if (Object.keys(next).length) return;
    router.replace("/(tabs)/home");
  };

  const onEmailChange = (v: string) => {
    setEmail(v);
    if (touched.email) setErrors((prev) => ({ ...prev, email: validate(v, password).email }));
  };
  const onPassChange = (v: string) => {
    setPassword(v);
    if (touched.password) setErrors((prev) => ({ ...prev, password: validate(email, v).password }));
  };

  const hasError = Object.keys(errors).length > 0 && (touched.email || touched.password);

  return (
    <View className="flex-1 bg-[#FDFCF8] overflow-hidden">
      <View pointerEvents="none" className="absolute inset-0 overflow-hidden">
        <View className="absolute -top-20 -right-16 w-[240px] h-[240px] rounded-full bg-[#FFD9E3] opacity-[0.24]" />
        <View className="absolute top-[300px] -left-16 w-[200px] h-[200px] rounded-full bg-[#B4EBFF] opacity-[0.18]" />
        <Text numberOfLines={1} className="absolute left-0 right-0 text-center text-[180px] font-extrabold text-[#1B1C1A] opacity-[0.025] top-[46%] -translate-y-1/2" style={{ fontFamily: "Bricolage Grotesque" }}>
          02
        </Text>
      </View>

      <ScrollView
        removeClippedSubviews
        showsVerticalScrollIndicator={false}
        showsHorizontalScrollIndicator={false}
        horizontal={false}
        bounces={false}
        overScrollMode="never"
        keyboardShouldPersistTaps="handled"
        contentContainerStyle={{ flexGrow: 1, paddingTop: insets.top + 16, paddingBottom: insets.bottom + 16, paddingHorizontal: 24 }}
        contentContainerClassName="grow"
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
              02 / 03
            </Text>
          </View>

          <View className="mt-8">
            <Text className="text-[34px] font-extrabold leading-[36px] tracking-[-1.2px] text-[#1B1C1A]" style={{ fontFamily: "Bricolage Grotesque" }}>
              Masuk lagi,{"\n"}
              <Text className="text-[#864D61]">cerita lanjut.</Text>
            </Text>
            <Text className="mt-2.5 text-[14.5px] leading-6 text-[#514347]" style={{ fontFamily: "Plus Jakarta Sans" }}>
              Ruang privat kalian sudah menunggu — foto & catatan tetap rapi di tempat.
            </Text>
          </View>

          {hasError && (
            <View className="mt-4 flex-row items-start gap-2.5 rounded-[12px] border-[1.4px] border-[#ba1a1a] px-3.5 py-3" style={{ backgroundColor: C.errorContainer, shadowColor: C.ink, shadowOpacity: 1, shadowRadius: 0, shadowOffset: { width: 3, height: 3 } }}>
              <View className="w-7 h-7 rounded-full bg-[#ba1a1a] items-center justify-center mt-0.5">
                <AlertCircle size={14} color="#fff" strokeWidth={2.2} />
              </View>
              <View className="flex-1">
                <Text className="text-[13px] font-bold" style={{ fontFamily: "Bricolage Grotesque", color: C.onErrorContainer }}>
                  Periksa lagi, ada yang belum pas
                </Text>
                <Text className="text-[12px] leading-4 mt-0.5" style={{ fontFamily: "Plus Jakarta Sans", color: C.onErrorContainer }}>
                  Betulkan isian bertanda merah di bawah — kami kasih tau persis bagian mana.
                </Text>
              </View>
            </View>
          )}

          <View
            className="mt-5 bg-white rounded-[20px] border-[1.5px] p-5 pt-6"
            style={{ borderColor: hasError ? C.error : C.ink, shadowColor: C.ink, shadowOpacity: 1, shadowRadius: 0, shadowOffset: { width: 4, height: 4 } }}
          >
            <View className="absolute -top-2 left-7 z-10">
              <WashiTape w={56} rotate="-3deg" color={hasError ? C.errorContainer : C.yellow} />
            </View>
            <View className="absolute -top-2 right-8 z-10">
              <WashiTape w={44} rotate="3deg" color={C.blueSoft} />
            </View>

            <View className="gap-5">
              <NotebookInput label="EMAIL" value={email} onChangeText={onEmailChange} placeholder="kamu@email.com" icon={Mail} keyboardType="email-address" error={touched.email ? errors.email : undefined} onBlur={() => setTouched((s) => ({ ...s, email: true }))} />
              <NotebookInput label="KATA SANDI" value={password} onChangeText={onPassChange} placeholder="••••••••" icon={Lock} secure error={touched.password ? errors.password : undefined} onBlur={() => setTouched((s) => ({ ...s, password: true }))} />
              <View className="flex-row justify-end -mt-1">
                <Pressable>
                  <Text className="text-[12px] font-bold text-[#1B1C1A] underline" style={{ fontFamily: "Space Mono" }}>
                    Lupa kata sandi?
                  </Text>
                </Pressable>
              </View>
            </View>

            <View className="mt-5 flex-row items-center gap-2 bg-[#FDFCF8] border border-black/5 rounded-full px-3 py-2 self-start" style={{ transform: [{ rotate: "-0.4deg" }] }}>
              <Lock size={11} color={C.outlineStrong} strokeWidth={1.8} />
              <Text className="text-[11px] text-[#514347]" style={{ fontFamily: "Space Mono" }}>
                Terenkripsi • hanya kalian berdua
              </Text>
            </View>
          </View>

          <View className="flex-1 min-h-[12px]" />

          <View className="mt-6 gap-3">
            <SwipeButton label="Geser untuk masuk" onComplete={handleSwipe} hint="GESER UNTUK MASUK" />
            <View className="flex-row items-center justify-center gap-1.5 py-1">
              <Text className="text-[13px] text-[#514347]" style={{ fontFamily: "Space Mono" }}>
                Belum punya ruang?
              </Text>
              <Link href="/register" asChild>
                <Pressable>
                  <Text className="text-[13px] font-bold text-[#1B1C1A] underline" style={{ fontFamily: "Space Mono" }}>
                    Daftar
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
