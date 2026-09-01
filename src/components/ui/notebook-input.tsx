import { useState } from "react";
import { View, Text, TextInput, Pressable } from "react-native";
import { Eye, EyeOff, AlertCircle } from "lucide-react-native";

const C = {
  ink: "#1B1C1A",
  muted: "#514347",
  outlineStrong: "#837377",
  error: "#ba1a1a",
  errorContainer: "#ffdad6",
  onErrorContainer: "#93000a",
};

type Props = {
  label: string;
  value: string;
  onChangeText: (t: string) => void;
  placeholder?: string;
  icon: React.ElementType;
  secure?: boolean;
  keyboardType?: "default" | "email-address";
  autoCapitalize?: "none" | "sentences" | "words" | "characters";
  error?: string;
  onBlur?: () => void;
};

export function NotebookInput({ label, value, onChangeText, placeholder, icon: Icon, secure, keyboardType, autoCapitalize = "none", error, onBlur }: Props) {
  const [show, setShow] = useState(false);
  const isPassword = !!secure;
  const hasError = !!error;

  return (
    <View className="gap-1.5">
      <View className="flex-row items-center gap-1.5">
        <Icon size={13} color={hasError ? C.error : C.outlineStrong} strokeWidth={2} />
        <Text
          className="text-[11px] font-bold tracking-[0.8px]"
          style={{ fontFamily: "Space Mono", color: hasError ? C.error : "#837377" }}
        >
          {label}
        </Text>
        {hasError && <View className="w-1 h-1 rounded-full bg-[#ba1a1a] ml-0.5" />}
      </View>

      {/* ruled notebook line - error uses #ba1a1a border */}
      <View
        className="flex-row items-end gap-2 pb-2 pt-1 border-b-[1.6px]"
        style={{ borderColor: hasError ? C.error : C.ink }}
      >
        <TextInput
          value={value}
          onChangeText={onChangeText}
          onBlur={onBlur}
          placeholder={placeholder}
          placeholderTextColor="#B8A9AC"
          secureTextEntry={isPassword && !show}
          keyboardType={keyboardType}
          autoCapitalize={autoCapitalize}
          className="flex-1 text-[15px] p-0"
          style={{ fontFamily: "Plus Jakarta Sans", paddingVertical: 0, color: hasError ? C.error : C.ink }}
        />
        {isPassword ? (
          <Pressable onPress={() => setShow((s) => !s)} className="p-1 -mr-1" hitSlop={8}>
            {show ? <EyeOff size={18} color={hasError ? C.error : C.muted} strokeWidth={1.7} /> : <Eye size={18} color={hasError ? C.error : C.muted} strokeWidth={1.7} />}
          </Pressable>
        ) : (
          <View className="w-[18px] h-[1.5px] rounded-full mb-1.5" style={{ backgroundColor: hasError ? C.error : C.ink, opacity: hasError ? 1 : 0.3 }} />
        )}
      </View>

      {/* error message - design.md error-container */}
      {hasError && (
        <View
          className="flex-row items-start gap-1.5 rounded-[8px] border px-2.5 py-1.5"
          style={{ backgroundColor: C.errorContainer, borderColor: "#E8B4B0" }}
        >
          <AlertCircle size={13} color={C.error} strokeWidth={2} style={{ marginTop: 1 }} />
          <Text className="flex-1 text-[11px] leading-[14px]" style={{ fontFamily: "Space Mono", color: C.onErrorContainer }}>
            {error}
          </Text>
        </View>
      )}
    </View>
  );
}
