import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { DropletIcon, UtensilsIcon, BarChartIcon, UsersIcon } from "lucide-react";
import Link from "next/link";

export default function LandingPage() {
  return (
    <div className="flex flex-col min-h-screen">
      <header className="px-4 lg:px-12 pt-12 h-14 flex items-center ">
        <Link className="flex items-center justify-center" href="#">
          {/* <PooIcon className="h-6 w-6 mr-2" /> */}
          <h1 className="font-bold text-8xl">Poo プー</h1>
        </Link>
        <nav className="ml-auto flex gap-4 sm:gap-6">
          <Link className="text-2xl font-medium hover:underline underline-offset-4" href="#features">
            Features
          </Link>
          <Link className="text-2xl font-medium hover:underline underline-offset-4" href="#benefits">
            Benefits
          </Link>
          <Link className="text-2xl font-medium hover:underline underline-offset-4" href="#community">
            Community
          </Link>
        </nav>
      </header>
      <main className="flex flex-col">
        <section className="flex items-center justify-center w-full py-12 md:py-24 lg:py-32 xl:py-48 bg-brown-50">
          <div className="container px-4 md:px-6">
            <div className="flex flex-col items-center space-y-4 text-center">
              <div className="space-y-2">
                <h1 className="text-3xl font-bold tracking-tighter sm:text-4xl md:text-5xl lg:text-6xl/none">
                  うんちを管理しよう
                </h1>
                <p className="mx-auto max-w-[700px] text-gray-500 md:text-xl">
                  PoopTrack helps you monitor your digestive health, optimize your diet, and improve your overall
                  well-being.
                </p>
              </div>
              <Button size="lg">ダウンロード</Button>
            </div>
          </div>
        </section>
        <section id="features" className="flex items-center justify-center w-full py-12 md:py-24 lg:py-32">
          <div className="container px-4 md:px-6">
            <h2 className="text-3xl font-bold tracking-tighter sm:text-5xl text-center mb-12">Key Features</h2>
            <div className="grid gap-10 sm:grid-cols-2 md:grid-cols-3">
              <div className="flex flex-col items-center space-y-3 text-center">
                {/* <PooIcon className="h-12 w-12 text-brown-500" /> */}
                <h3 className="text-xl font-bold">Poop Tracking</h3>
                <p className="text-gray-500">Record shape, hardness, frequency, volume, and anomalies.</p>
              </div>
              <div className="flex flex-col items-center space-y-3 text-center">
                <DropletIcon className="h-12 w-12 text-blue-500" />
                <h3 className="text-xl font-bold">Water Intake</h3>
                <p className="text-gray-500">Monitor your daily water consumption for optimal hydration.</p>
              </div>
              <div className="flex flex-col items-center space-y-3 text-center">
                <UtensilsIcon className="h-12 w-12 text-green-500" />
                <h3 className="text-xl font-bold">Food Diary</h3>
                <p className="text-gray-500">Log your meals and track calorie intake.</p>
              </div>
              <div className="flex flex-col items-center space-y-3 text-center">
                <BarChartIcon className="h-12 w-12 text-purple-500" />
                <h3 className="text-xl font-bold">Health Insights</h3>
                <p className="text-gray-500">Get personalized analytics and health recommendations.</p>
              </div>
              <div className="flex flex-col items-center space-y-3 text-center">
                <UsersIcon className="h-12 w-12 text-red-500" />
                <h3 className="text-xl font-bold">Community Support</h3>
                <p className="text-gray-500">Connect with others and share experiences in our chat forums.</p>
              </div>
            </div>
          </div>
        </section>
        <section id="benefits" className="flex items-center justify-center w-full py-12 md:py-24 lg:py-32 bg-brown-50">
          <div className="container px-4 md:px-6">
            <h2 className="text-3xl font-bold tracking-tighter sm:text-5xl text-center mb-12">Health Benefits</h2>
            <div className="grid gap-8 sm:grid-cols-2 lg:grid-cols-3">
              <div className="flex flex-col space-y-2">
                <h3 className="text-xl font-bold">Early Detection</h3>
                <p className="text-gray-500">Identify potential health issues before they become serious problems.</p>
              </div>
              <div className="flex flex-col space-y-2">
                <h3 className="text-xl font-bold">Digestive Optimization</h3>
                <p className="text-gray-500">Improve your gut health and overall digestive function.</p>
              </div>
              <div className="flex flex-col space-y-2">
                <h3 className="text-xl font-bold">Diet Improvement</h3>
                <p className="text-gray-500">Understand how different foods affect your digestive system.</p>
              </div>
              <div className="flex flex-col space-y-2">
                <h3 className="text-xl font-bold">Hydration Awareness</h3>
                <p className="text-gray-500">Maintain proper hydration levels for better overall health.</p>
              </div>
              <div className="flex flex-col space-y-2">
                <h3 className="text-xl font-bold">Stress Reduction</h3>
                <p className="text-gray-500">Alleviate anxiety about digestive health through informed tracking.</p>
              </div>
              <div className="flex flex-col space-y-2">
                <h3 className="text-xl font-bold">Personalized Insights</h3>
                <p className="text-gray-500">Receive tailored advice based on your unique health data.</p>
              </div>
            </div>
          </div>
        </section>
        <section id="community" className="flex items-center justify-center w-full py-12 md:py-24 lg:py-32">
          <div className="container px-4 md:px-6">
            <div className="flex flex-col items-center justify-center space-y-4 text-center">
              <div className="space-y-2">
                <h2 className="text-3xl font-bold tracking-tighter sm:text-5xl">Join Our Community</h2>
                <p className="max-w-[900px] text-gray-500 md:text-xl/relaxed lg:text-base/relaxed xl:text-xl/relaxed">
                  Connect with others, share experiences, and learn from our supportive community. Together, we can
                  improve our digestive health and overall well-being.
                </p>
              </div>
              <Button>Join Now</Button>
            </div>
          </div>
        </section>
        <section className="flex items-center justify-center w-full py-12 md:py-24 lg:py-32 bg-brown-100">
          <div className="container px-4 md:px-6">
            <div className="flex flex-col items-center justify-center space-y-4 text-center">
              <div className="space-y-2">
                <h2 className="text-3xl font-bold tracking-tighter sm:text-4xl md:text-5xl">
                  Ready to Transform Your Health?
                </h2>
                <p className="max-w-[600px] text-gray-500 md:text-xl/relaxed lg:text-base/relaxed xl:text-xl/relaxed">
                  Start tracking your digestive health today and take control of your well-being.
                </p>
              </div>
              <div className="w-full max-w-sm space-y-2">
                <form className="flex space-x-2">
                  <Input className="max-w-lg flex-1" placeholder="Enter your email" type="email" />
                  <Button type="submit">Get Started</Button>
                </form>
                <p className="text-xs text-gray-500">
                  By signing up, you agree to our{" "}
                  <Link className="underline underline-offset-2" href="#">
                    Terms & Conditions
                  </Link>
                </p>
              </div>
            </div>
          </div>
        </section>
      </main>
      <footer className="flex flex-col gap-2 sm:flex-row py-6 w-full shrink-0 items-center px-4 md:px-6 border-t">
        <p className="text-xs text-gray-500">© 2023 PoopTrack. All rights reserved.</p>
        <nav className="sm:ml-auto flex gap-4 sm:gap-6">
          <Link className="text-xs hover:underline underline-offset-4" href="#">
            Terms of Service
          </Link>
          <Link className="text-xs hover:underline underline-offset-4" href="#">
            Privacy
          </Link>
        </nav>
      </footer>
    </div>
  );
}
