import { useState, useEffect } from "react";
import { View, Text, Pressable, Modal, TextInput, Platform } from "react-native";
import { MapPin, X, Navigation, Search, LocateFixed } from "lucide-react-native";
import { WashiTape } from "./washi-tape";

const C = { ink: "#1B1C1A", pink: "#FFD9E3", yellow: "#EEE199", blue: "#B4EBFF", error: "#ba1a1a", errorBg: "#ffdad6" };

// Lazy load MapView only on native to avoid web crash
let MapView: any = null;
let Marker: any = null;
try {
  if (Platform.OS !== "web") {
    const Maps = require("react-native-maps");
    MapView = Maps.default;
    Marker = Maps.Marker;
  }
} catch {}

const PRESETS = [
  { label: "SKYE Bar, Jakarta", sub: "Rooftop • Senayan", lat: -6.225, lng: 106.8 },
  { label: "Taman Suropati", sub: "Taman • Menteng", lat: -6.199, lng: 106.83 },
  { label: "CGV Grand Indonesia", sub: "Bioskop • Thamrin", lat: -6.195, lng: 106.82 },
  { label: "Kopi Nako Dharmawangsa", sub: "Kafe • JakSel", lat: -6.26, lng: 106.8 },
];

export function TactileMapField({ value, onChange, error }: { value: string; onChange: (v: string) => void; error?: string }) {
  const [open, setOpen] = useState(false);
  const [draft, setDraft] = useState(value);
  const [coords, setCoords] = useState({ latitude: -6.2, longitude: 106.82 });
  const [query, setQuery] = useState("");

  useEffect(() => { setDraft(value); }, [value]);

  const confirm = (label?: string) => {
    const v = label ?? draft;
    if (!v.trim()) return;
    onChange(v.trim());
    setOpen(false);
  };

  const pickPreset = (p: typeof PRESETS[0]) => {
    setCoords({ latitude: p.lat, longitude: p.lng });
    setDraft(p.label);
  };

  return (
    <>
      <Pressable onPress={() => { setDraft(value); setOpen(true); }} className="flex-row items-end gap-2 border-b-[1.6px] pb-2 pt-1" style={{ borderColor: error ? C.error : C.ink }}>
        <View className="w-8 h-8 rounded-[8px] border border-[#1B1C1A] items-center justify-center" style={{ backgroundColor: value ? C.yellow : "#fff" }}>
          <MapPin size={14} color={C.ink} strokeWidth={1.8} />
        </View>
        <View className="flex-1">
          <Text className="text-[11px] font-bold tracking-[0.6px]" style={{ fontFamily: "Space Mono", color: error ? C.error : "#837377" }}>
            TEMPAT KETEMU
          </Text>
          <Text className="text-[14px] font-bold mt-0.5" numberOfLines={1} style={{ fontFamily: "Plus Jakarta Sans", color: value ? C.ink : "#B8A9AC" }}>
            {value || "Pilih dari peta"}
          </Text>
        </View>
        <View className="w-7 h-7 rounded-full bg-[#FDFCF8] border border-[#1B1C1A] items-center justify-center">
          <Navigation size={12} color={C.ink} strokeWidth={2} />
        </View>
      </Pressable>
      {error && <Text className="text-[11px] mt-1" style={{ fontFamily: "Space Mono", color: C.error }}>{error}</Text>}

      <Modal visible={open} transparent animationType="slide" onRequestClose={() => setOpen(false)}>
        <View className="flex-1 bg-[#1B1C1A]/40 justify-end">
          <Pressable className="flex-1" onPress={() => setOpen(false)} />
          <View className="bg-[#FDFCF8] rounded-t-[20px] border-t-[1.5px] border-x-[1.5px] border-[#1B1C1A] px-5 pt-5 pb-6 max-h-[90%]" style={{ shadowColor: C.ink, shadowOpacity: 1, shadowRadius: 0, shadowOffset: { width: 0, height: -4 } }}>
            <View className="absolute -top-2 left-1/2 -translate-x-1/2 z-10">
              <WashiTape w={52} rotate="-2deg" color={C.yellow} />
            </View>
            <View className="w-10 h-1.5 rounded-full bg-[#1B1C1A] opacity-20 self-center mb-4" />
            <View className="flex-row items-center justify-between">
              <View className="flex-row items-center gap-2">
                <View className="w-8 h-8 rounded-full bg-[#EEE199] border border-[#1B1C1A] items-center justify-center">
                  <MapPin size={14} color={C.ink} strokeWidth={1.8} />
                </View>
                <View>
                  <Text className="text-[16px] font-extrabold text-[#1B1C1A]" style={{ fontFamily: "Bricolage Grotesque" }}>
                    Pilih tempat
                  </Text>
                  <Text className="text-[11px] text-[#837377]" style={{ fontFamily: "Space Mono" }}>
                    Tap peta atau ketik — kayak nempel pin
                  </Text>
                </View>
              </View>
              <Pressable onPress={() => setOpen(false)} className="w-8 h-8 rounded-full bg-white border border-[#1B1C1A] items-center justify-center">
                <X size={16} color={C.ink} />
              </Pressable>
            </View>

            {/* Map canvas - paper layer - always visible preview */}
            <View className="mt-4 h-[240px] rounded-[16px] border-[1.5px] border-[#1B1C1A] overflow-hidden bg-[#FDFCF8]" style={{ shadowColor: C.ink, shadowOpacity: 1, shadowRadius: 0, shadowOffset: { width: 3, height: 3 } }}>
              {/* paper map texture */}
              <View className="absolute inset-0 bg-[#FDFCF8]">
                {/* grid streets - tactile */}
                <View className="absolute left-[22%] top-0 bottom-0 w-[1.5px] bg-[#1B1C1A] opacity-[0.06]" />
                <View className="absolute left-[58%] top-0 bottom-0 w-[1.5px] bg-[#1B1C1A] opacity-[0.06]" />
                <View className="absolute top-[30%] left-0 right-0 h-[1.5px] bg-[#1B1C1A] opacity-[0.06]" />
                <View className="absolute top-[62%] left-0 right-0 h-[1.5px] bg-[#1B1C1A] opacity-[0.06]" />
                <View className="absolute left-[38%] top-[14%] w-2 h-2 rounded-full bg-[#B4EBFF] border border-[#1B1C1A] opacity-60" />
                <View className="absolute right-[18%] bottom-[28%] w-3 h-3 rounded-full bg-[#FFD9E3] border border-[#1B1C1A] opacity-60" />
                {/* washi hint */}
                <View className="absolute top-2 left-2 bg-white border border-[#1B1C1A] rounded-full px-2 py-1 flex-row items-center gap-1 shadow-sm">
                  <View className="w-1.5 h-1.5 rounded-full bg-[#864D61]" />
                  <Text className="text-[10px] font-bold text-[#1B1C1A]" style={{ fontFamily: "Space Mono" }}>
                    PRATINJAU PETA KERTAS
                  </Text>
                </View>
                <View className="absolute bottom-12 right-3 bg-[#1B1C1A] rounded-full px-2 py-1 flex-row items-center gap-1">
                  <LocateFixed size={10} color="#fff" />
                  <Text className="text-[10px] font-bold text-white" style={{ fontFamily: "Space Mono" }}>
                    {coords.latitude.toFixed(3)}, {coords.longitude.toFixed(3)}
                  </Text>
                </View>
              </View>

              {/* draggable pin - centered */}
              <View className="absolute left-1/2 top-1/2 -translate-x-1/2 -translate-y-1/2 items-center" style={{ transform: [{ translateX: -18 }, { translateY: -18 }] }}>
                <View className="w-9 h-9 rounded-full bg-[#864D61] border-[1.6px] border-[#1B1C1A] items-center justify-center" style={{ shadowColor: C.ink, shadowOpacity: 1, shadowRadius: 0, shadowOffset: { width: 2, height: 2 } }}>
                  <MapPin size={16} color="#fff" fill="#FFD9E3" strokeWidth={1.8} />
                </View>
                <View className="w-2 h-2 rounded-full bg-[#1B1C1A] opacity-20 mt-1" />
              </View>

              {/* native map on top when available - clipped to same paper shape */}
              {Platform.OS !== "web" && MapView && (
                <MapView
                  style={{ flex: 1, opacity: 0.92 }}
                  initialRegion={{ latitude: coords.latitude, longitude: coords.longitude, latitudeDelta: 0.015, longitudeDelta: 0.015 }}
                  onPress={(e: any) => setCoords(e.nativeEvent.coordinate)}
                >
                  <Marker coordinate={coords} draggable onDragEnd={(e: any) => setCoords(e.nativeEvent.coordinate)}>
                    <View className="w-9 h-9 rounded-full bg-[#864D61] border-[1.6px] border-[#1B1C1A] items-center justify-center">
                      <MapPin size={16} color="#fff" fill="#FFD9E3" strokeWidth={1.8} />
                    </View>
                  </Marker>
                </MapView>
              )}

              {/* bottom search */}
              <View className="absolute bottom-2 left-2 right-2 bg-white border border-[#1B1C1A] rounded-full px-2.5 py-1.5 flex-row items-center gap-1.5" style={{ shadowColor: C.ink, shadowOpacity: 0.08, shadowRadius: 0, shadowOffset: { width: 2, height: 2 } }}>
                <Search size={12} color="#837377" />
                <TextInput value={draft} onChangeText={setDraft} placeholder="Ketik nama tempat..." placeholderTextColor="#B8A9AC" className="flex-1 text-[12px] p-0" style={{ fontFamily: "Space Mono", paddingVertical: 0 }} />
              </View>
            </View>

            {/* presets - Dymo chips */}
            <View className="mt-3">
              <Text className="text-[11px] font-bold tracking-[0.6px] text-[#837377]" style={{ fontFamily: "Space Mono" }}>
                CEPAT PILIH
              </Text>
              <View className="flex-row flex-wrap gap-2 mt-2">
                {PRESETS.filter((p) => !query || p.label.toLowerCase().includes(query.toLowerCase())).map((p) => (
                  <Pressable key={p.label} onPress={() => pickPreset(p)} className="bg-white border border-[#1B1C1A] rounded-full px-3 py-1.5 flex-row items-center gap-1.5" style={{ shadowColor: C.ink, shadowOpacity: 0.06, shadowRadius: 0, shadowOffset: { width: 2, height: 2 } }}>
                    <MapPin size={12} color={C.ink} />
                    <Text className="text-[11px] font-bold text-[#1B1C1A]" style={{ fontFamily: "Space Mono" }}>
                      {p.label}
                    </Text>
                  </Pressable>
                ))}
              </View>
            </View>

            <View className="mt-4 flex-row gap-2">
              <Pressable onPress={() => setOpen(false)} className="flex-1 bg-white rounded-full border-[1.4px] border-[#1B1C1A] py-3 items-center">
                <Text className="text-[13px] font-bold text-[#1B1C1A]" style={{ fontFamily: "Space Mono" }}>
                  Batal
                </Text>
              </Pressable>
              <Pressable onPress={() => confirm()} className="flex-[1.6] bg-[#864D61] rounded-full border-[1.6px] border-[#1B1C1A] py-3 flex-row items-center justify-center gap-1.5" style={{ shadowColor: C.ink, shadowOpacity: 1, shadowRadius: 0, shadowOffset: { width: 3, height: 3 } }}>
                <Text className="text-[13px] font-extrabold text-white" style={{ fontFamily: "Bricolage Grotesque" }}>
                  Pakai tempat ini
                </Text>
                <View className="w-5 h-5 rounded-full bg-white items-center justify-center">
                  <MapPin size={12} color={C.ink} />
                </View>
              </Pressable>
            </View>

            <Text className="text-center text-[11px] text-[#837377] mt-2.5" style={{ fontFamily: "Space Mono" }}>
              Pin bisa digeser — kayak nempel pin di peta kertas
            </Text>
          </View>
        </View>
      </Modal>
    </>
  );
}
