import coffee from "@/assets/horeca-coffee.jpg";
import oven from "@/assets/horeca-oven.jpg";
import fridge from "@/assets/horeca-fridge.jpg";
import mixer from "@/assets/horeca-mixer.jpg";
import dishwasher from "@/assets/horeca-dishwasher.jpg";
import induction from "@/assets/horeca-induction.jpg";

export type HorecaCategory =
  | "Кавомашини"
  | "Печі"
  | "Холодильне"
  | "Міксери"
  | "Посудомийні"
  | "Плити";

export type HorecaItem = {
  id: string;
  name: string;
  brand: string;
  tagline: string;
  description: string;
  pricePerDay: number;
  priceBuy: number;
  category: HorecaCategory;
  image: string;
  power: string;
  dimensions: string;
  warranty: string;
  specs: { label: string; value: string }[];
};

export const horecaCategories: { id: HorecaCategory; emoji: string }[] = [
  { id: "Кавомашини", emoji: "☕" },
  { id: "Печі", emoji: "🔥" },
  { id: "Холодильне", emoji: "❄️" },
  { id: "Міксери", emoji: "🥣" },
  { id: "Посудомийні", emoji: "🫧" },
  { id: "Плити", emoji: "🍳" },
];

export const horecaItems: HorecaItem[] = [
  {
    id: "barista-duo",
    name: "Barista Duo 2GR",
    brand: "Crema Pro",
    tagline: "Дві групи. PID-контроль. 240 чашок/год.",
    description:
      "Професійна еспресо-машина з двома групами, PID-температурним контролем та паровим бойлером 11 л. Ідеально для кав'ярень з потоком до 240 чашок на годину.",
    pricePerDay: 35,
    priceBuy: 4900,
    category: "Кавомашини",
    image: coffee,
    power: "4.2 кВт",
    dimensions: "780×560×530 мм",
    warranty: "24 міс",
    specs: [
      { label: "Групи", value: "2" },
      { label: "Бойлер", value: "11 л" },
      { label: "Тиск", value: "9 бар" },
      { label: "Вага", value: "62 кг" },
    ],
  },
  {
    id: "convex-60",
    name: "Convex 60 Smart",
    brand: "ThermoLine",
    tagline: "Конвекційна піч 6 рівнів GN 1/1.",
    description:
      "Конвекційна піч з пароуприскуванням, сенсорною панеллю та автоматичним миттям. Економія електроенергії до 30%.",
    pricePerDay: 28,
    priceBuy: 3450,
    category: "Печі",
    image: oven,
    power: "9.5 кВт",
    dimensions: "900×850×950 мм",
    warranty: "24 міс",
    specs: [
      { label: "Рівні", value: "6 × GN 1/1" },
      { label: "Темп.", value: "до 270 °C" },
      { label: "Пара", value: "Так" },
      { label: "Вага", value: "98 кг" },
    ],
  },
  {
    id: "polar-700",
    name: "Polar 700 Glass",
    brand: "FrostWorks",
    tagline: "Скляні двері. -2…+8 °C. 700 л.",
    description:
      "Холодильна шафа з динамічним охолодженням, LED-підсвіткою та електронним керуванням. Енергоклас A.",
    pricePerDay: 18,
    priceBuy: 1890,
    category: "Холодильне",
    image: fridge,
    power: "0.55 кВт",
    dimensions: "680×800×2050 мм",
    warranty: "36 міс",
    specs: [
      { label: "Об'єм", value: "700 л" },
      { label: "Темп.", value: "-2…+8 °C" },
      { label: "Двері", value: "Скляні" },
      { label: "Клас", value: "A" },
    ],
  },
  {
    id: "doughmaster-20",
    name: "DoughMaster 20",
    brand: "Crema Pro",
    tagline: "Планетарний міксер 20 л, 3 швидкості.",
    description:
      "Планетарний міксер для пекарень та кондитерських з нержавіючою чашею 20 л і трьома насадками в комплекті.",
    pricePerDay: 14,
    priceBuy: 1290,
    category: "Міксери",
    image: mixer,
    power: "1.1 кВт",
    dimensions: "520×480×820 мм",
    warranty: "24 міс",
    specs: [
      { label: "Чаша", value: "20 л" },
      { label: "Швидкості", value: "3" },
      { label: "Насадки", value: "3 шт" },
      { label: "Вага", value: "94 кг" },
    ],
  },
  {
    id: "aqua-clean-50",
    name: "AquaClean 50",
    brand: "ThermoLine",
    tagline: "60 кошиків/год. Подвійна ізоляція.",
    description:
      "Підстільна посудомийна машина з циклом 90/120/180 с, дренажним насосом та системою пом'якшення води.",
    pricePerDay: 16,
    priceBuy: 1650,
    category: "Посудомийні",
    image: dishwasher,
    power: "3.4 кВт",
    dimensions: "590×600×820 мм",
    warranty: "24 міс",
    specs: [
      { label: "Кошик", value: "500×500 мм" },
      { label: "Цикл", value: "90/120/180 с" },
      { label: "Насос", value: "Дренажний" },
      { label: "Вага", value: "55 кг" },
    ],
  },
  {
    id: "induction-quad",
    name: "Induction Quad 4Z",
    brand: "FrostWorks",
    tagline: "4 зони індукції. Швидко й тихо.",
    description:
      "Індукційна плита з чотирма зонами по 3.5 кВт, цифровим керуванням та таймером. Без відкритого вогню.",
    pricePerDay: 22,
    priceBuy: 2190,
    category: "Плити",
    image: induction,
    power: "14 кВт",
    dimensions: "800×700×250 мм",
    warranty: "24 міс",
    specs: [
      { label: "Зони", value: "4 × 3.5 кВт" },
      { label: "Керування", value: "Сенсор" },
      { label: "Матеріал", value: "Склокераміка" },
      { label: "Вага", value: "32 кг" },
    ],
  },
];

export const getHorecaItem = (id: string) => horecaItems.find((i) => i.id === id);

export const formatUSD = (n: number) =>
  // Fixed locale to avoid SSR/CSR hydration mismatch
  n.toLocaleString("en-US");
