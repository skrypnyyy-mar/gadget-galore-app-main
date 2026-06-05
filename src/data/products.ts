import phone from "@/assets/product-phone.jpg";
import headphones from "@/assets/product-headphones.jpg";
import laptop from "@/assets/product-laptop.jpg";
import watch from "@/assets/product-watch.jpg";
import earbuds from "@/assets/product-earbuds.jpg";
import tablet from "@/assets/product-tablet.jpg";

export type Product = {
  id: string;
  name: string;
  tagline: string;
  description: string;
  price: number;
  category: "Phones" | "Laptops" | "Audio" | "Wearables" | "Tablets";
  image: string;
  rating: number;
  reviews: number;
  colors: string[];
};

export const categories = ["All", "Phones", "Laptops", "Audio", "Wearables", "Tablets"] as const;

export const products: Product[] = [
  {
    id: "nova-pro",
    name: "Nova Pro",
    tagline: "Pro-grade camera. Titanium body.",
    description:
      "Nova Pro поєднує титановий корпус, дисплей ProMotion 120 Hz та потрійну камерну систему з оптичним зумом 5×.",
    price: 1199,
    category: "Phones",
    image: phone,
    rating: 4.9,
    reviews: 1284,
    colors: ["#1f1f22", "#d6d2c4", "#3a4a5a"],
  },
  {
    id: "aura-book-16",
    name: "Aura Book 16",
    tagline: "Тиша. Потужність. До 22 годин.",
    description:
      "Ультратонкий ноутбук на чипі M-серії з 16-дюймовим Liquid Retina XDR та активним охолодженням без шуму.",
    price: 2499,
    category: "Laptops",
    image: laptop,
    rating: 4.8,
    reviews: 642,
    colors: ["#9aa0a6", "#1f1f22"],
  },
  {
    id: "echo-studio",
    name: "Echo Studio",
    tagline: "Просторове аудіо. Adaptive Noise Cancel.",
    description:
      "Бездротові навушники з адаптивним шумозаглушенням, до 40 годин роботи та преміальним просторовим звуком.",
    price: 549,
    category: "Audio",
    image: headphones,
    rating: 4.7,
    reviews: 2103,
    colors: ["#f4f4f5", "#1f1f22"],
  },
  {
    id: "pulse-watch",
    name: "Pulse Watch",
    tagline: "Здоров'я на зап'ясті, 24/7.",
    description:
      "Завжди увімкнений Retina-дисплей, ЕКГ, GPS та до 36 годин автономної роботи.",
    price: 449,
    category: "Wearables",
    image: watch,
    rating: 4.8,
    reviews: 1890,
    colors: ["#1f1f22", "#d6d2c4"],
  },
  {
    id: "buds-mini",
    name: "Buds Mini",
    tagline: "Компактний звук, що зникає у вусі.",
    description:
      "Найменші бездротові навушники з активним шумозаглушенням і кейсом MagSafe.",
    price: 229,
    category: "Audio",
    image: earbuds,
    rating: 4.6,
    reviews: 3421,
    colors: ["#ffffff"],
  },
  {
    id: "slate-pad-12",
    name: "Slate Pad 12",
    tagline: "Студія, кінотеатр і блокнот в одному.",
    description:
      "12,9-дюймовий дисплей Liquid Retina, підтримка стилуса та клавіатури, чип M-серії.",
    price: 1099,
    category: "Tablets",
    image: tablet,
    rating: 4.7,
    reviews: 980,
    colors: ["#9aa0a6", "#1f1f22"],
  },
];

export const getProduct = (id: string) => products.find((p) => p.id === id);
