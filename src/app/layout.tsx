import type { Metadata } from "next";
import type { ReactNode } from "react";
import { siteConfig } from "@/config/site";
import { CartProvider } from "@/features/cart/components/cart-provider";
import "./globals.css";

export const metadata: Metadata = {
  metadataBase: new URL("https://valdra.store"),
  title: { default: "VALDRA — Urban Technical", template: "%s | VALDRA" },
  description: siteConfig.description,
  robots: { index: process.env.NODE_ENV === "production", follow: process.env.NODE_ENV === "production" },
};

export default function RootLayout({ children }: Readonly<{ children: ReactNode }>) {
  return (
    <html
      lang={siteConfig.locale}
      className="h-full antialiased"
    >
      <body className="min-h-full bg-background text-foreground"><CartProvider>{children}</CartProvider></body>
    </html>
  );
}
