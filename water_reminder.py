import requests
import json
import time
import schedule
from datetime import datetime

# Discord webhook URL
WEBHOOK_URL = "https://discord.com/api/webhooks/1400091789855297657/ihY68RzjaTvNzAfMtNQsJRe4jOY4tWVzrP5iW_exYXPM-FLD-hSiVhxom7SXi26G4pVl"

def send_water_reminder():
    """Kirim notifikasi water reminder ke Discord"""
    
    # Pesan reminder yang bervariasi
    messages = [
        "💧 **Waktunya minum air!** 💧\nJangan lupa untuk minum air putih ya! Tubuh kamu butuh hidrasi yang cukup.",
        "🥤 **Reminder: Minum Air!** 🥤\nSudah berapa gelas air yang kamu minum hari ini? Yuk, minum lagi!",
        "💦 **Hydration Time!** 💦\nTubuh kamu terdiri dari 60% air. Saatnya mengisi ulang tangki air kamu!",
        "🌊 **Air Alert!** 🌊\nMinum air putih sekarang untuk menjaga kesehatan dan konsentrasi kamu!",
        "💧 **Stay Hydrated!** 💧\nIngat: 8 gelas per hari adalah minimum. Sudah minum berapa gelas hari ini?"
    ]
    
    # Pilih pesan secara acak berdasarkan waktu
    import random
    current_time = datetime.now()
    random.seed(current_time.hour + current_time.minute)
    message = random.choice(messages)
    
    # Data yang akan dikirim
    data = {
        "content": message,
        "embeds": [
            {
                "title": "💧 Water Reminder Bot",
                "description": f"Reminder dikirim pada: {current_time.strftime('%d/%m/%Y %H:%M:%S')}",
                "color": 3447003,  # Warna biru
                "footer": {
                    "text": "Stay healthy, stay hydrated! 💪"
                },
                "thumbnail": {
                    "url": "https://cdn-icons-png.flaticon.com/512/1672/1672960.png"
                }
            }
        ]
    }
    
    try:
        # Kirim POST request ke webhook
        response = requests.post(
            WEBHOOK_URL,
            data=json.dumps(data),
            headers={"Content-Type": "application/json"}
        )
        
        if response.status_code == 204:
            print(f"✅ Water reminder berhasil dikirim pada {current_time.strftime('%H:%M:%S')}")
        else:
            print(f"❌ Gagal mengirim reminder. Status code: {response.status_code}")
            
    except Exception as e:
        print(f"❌ Error saat mengirim reminder: {str(e)}")

def test_webhook():
    """Test webhook untuk memastikan berfungsi"""
    data = {
        "content": "🧪 **Test Water Reminder Bot** 🧪\nBot berhasil dijalankan dan siap mengirim reminder!",
        "embeds": [
            {
                "title": "✅ Test Successful",
                "description": "Water reminder bot sudah aktif dan siap bekerja!",
                "color": 65280,  # Warna hijau
                "timestamp": datetime.now().isoformat()
            }
        ]
    }
    
    try:
        response = requests.post(
            WEBHOOK_URL,
            data=json.dumps(data),
            headers={"Content-Type": "application/json"}
        )
        
        if response.status_code == 204:
            print("✅ Test webhook berhasil!")
            return True
        else:
            print(f"❌ Test webhook gagal. Status code: {response.status_code}")
            return False
            
    except Exception as e:
        print(f"❌ Error saat test webhook: {str(e)}")
        return False

def main():
    """Main function untuk menjalankan scheduler"""
    print("🚀 Memulai Water Reminder Bot...")
    
    # Test webhook terlebih dahulu
    if not test_webhook():
        print("❌ Webhook test gagal. Pastikan URL webhook benar.")
        return
    
    # Schedule reminder setiap 2 jam dari jam 8 pagi sampai 8 malam
    schedule.every().day.at("08:00").do(send_water_reminder)
    schedule.every().day.at("10:00").do(send_water_reminder)
    schedule.every().day.at("12:00").do(send_water_reminder)
    schedule.every().day.at("14:00").do(send_water_reminder)
    schedule.every().day.at("16:00").do(send_water_reminder)
    schedule.every().day.at("18:00").do(send_water_reminder)
    schedule.every().day.at("20:00").do(send_water_reminder)
    
    print("📅 Schedule berhasil dibuat:")
    print("   - 08:00 WIB")
    print("   - 10:00 WIB") 
    print("   - 12:00 WIB")
    print("   - 14:00 WIB")
    print("   - 16:00 WIB")
    print("   - 18:00 WIB")
    print("   - 20:00 WIB")
    print("\n💧 Bot sedang berjalan... Tekan Ctrl+C untuk berhenti.")
    
    # Jalankan scheduler
    try:
        while True:
            schedule.run_pending()
            time.sleep(60)  # Check setiap menit
    except KeyboardInterrupt:
        print("\n🛑 Bot dihentikan oleh user.")

if __name__ == "__main__":
    main()
