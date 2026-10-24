<div align="center">

# 🩺 RISHEH Windows Toolkit
### Your Windows is having a moment. We've got a checklist. ☕🛠️
### ویندوزت قاطی کرده؟ بیا قدم‌به‌قدم پیداش کنیم! ✨

**Offline-first Windows diagnostics · عیب‌یابی آفلاین و انتخابی ویندوز**

![Windows](https://img.shields.io/badge/Windows-10%20%7C%2011-0078D4?style=for-the-badge&logo=windows)
![PowerShell](https://img.shields.io/badge/PowerShell-5.1-5391FE?style=for-the-badge&logo=powershell&logoColor=white)
![Status](https://img.shields.io/badge/Status-Preview-orange?style=for-the-badge)
![Brand](https://img.shields.io/badge/Made%20by-RISHEH-174A3A?style=for-the-badge)

**[فارسی](#-راهنمای-فارسی) · [English](#-english-guide) · [Safety](#-safety-first--اول-امنیت)**

</div>

---

> [!IMPORTANT]
> **Preview, not a certified repair product.** The toolkit's Windows GUI and repair flows have **not** been validated on real Windows 10/11 hardware in this release. No installer, digital signature, or automated Windows compatibility certification is provided.
>
> **نسخه آزمایشی:** اجرای واقعی رابط گرافیکی و عملیات تعمیر روی ویندوز ۱۰ و ۱۱ هنوز تأیید نشده است.

## ✨ What it does / چه کار می‌کند؟

| 🔎 Module | 🇮🇷 فارسی | 🇬🇧 English |
|---|---|---|
| 🩺 System | مشخصات سیستم و نشانه‌های اولیه مشکل | Overview & health hints |
| 🌐 Network | بررسی شبکه، DNS و اتصال | Network & DNS diagnostics |
| 💾 Storage | فضای دیسک و بررسی فایل‌سیستم | Disk checks & storage |
| ⚡ Performance | پردازش‌ها و سرویس‌ها | Processes & services |
| 🧰 Repair | اجرای انتخابی SFC / DISM | Opt-in Windows repair |
| 🛡️ Security | بررسی تنظیمات حفاظتی | Firewall & security status |
| 🔋 Power | وضعیت باتری و انرژی | Battery & power reports |
| 📋 Reports | گزارش HTML و JSON | Exportable diagnostics |

**Design philosophy:** Diagnose first → explain → ask permission → run → report.

## 🇮🇷 راهنمای فارسی

### شروع سریع

۱. بسته نسخه ۳ را از فایل توزیع‌شده همراه پروژه دریافت و استخراج کنید. **در حال حاضر Release رسمی در این مخزن منتشر نشده است.**

۲. روی `Start-Toolkit.cmd` برای رابط گرافیکی یا `Start-CLI.cmd` برای حالت متنی دوبار کلیک کنید.

۳. ابتدا بررسی‌های فقط‌خواندنی را اجرا کنید. عملیات تعمیر را تنها پس از بررسی نتیجه و با تأیید آگاهانه انجام دهید.

**پیش‌نیاز:** Windows 10/11 و Windows PowerShell 5.1؛ نصب Python برای اجرای ابزار لازم نیست.

### 🔒 اصول ایمنی

- بررسی و تعمیر، دو کار متفاوت‌اند. تعمیرات باید با تأیید صریح انجام شوند.
- برخی عملیات نیازمند دسترسی Administrator هستند.
- گزارش کامل ممکن است نام رایانه، IP و جزئیات شخصی داشته باشد؛ قبل از اشتراک‌گذاری بررسی کنید.
- برای اجرا **Windows Defender یا Execution Policy را غیرفعال نکنید**.
- پیش از تعمیر دیسک و تغییرات سیستمی از اطلاعات مهم نسخه پشتیبان تهیه کنید.
- نتایج «Health Insights» صرفاً سرنخ‌اند و تشخیص قطعی سخت‌افزار نیستند.

### 🧪 تست و کیفیت

```powershell
# Structural tests (Python only needed for contributors)
python -m unittest discover -s tests -v

# Self-test on Windows
powershell.exe -NoProfile -File .\Toolkit.ps1 -SelfTest
```

> [!WARNING]
> تست‌های ساختاری جایگزین تست عملی روی Windows 10/11 نیستند. وضعیت تست و محدودیت‌ها باید در هر انتشار ثبت شوند.

## 🇬🇧 English guide

### Quick start

1. Obtain and extract the **v3 distribution ZIP**. A verified GitHub Release is **not yet published**.
2. Run `Start-Toolkit.cmd` for GUI or `Start-CLI.cmd` for the text interface.
3. Start with read-only checks; use repair commands only after reviewing the output and explicitly confirming the action.

**Requirements:** Windows 10/11, Windows PowerShell 5.1. Python is not required to run the toolkit.

### What makes this different?

- 🧭 **Diagnostics first** — gather evidence before proposing changes.
- 🛑 **Consent for repairs** — no surprise fixes.
- 📦 **Offline-first** — no mandatory external service or telemetry.
- 🧾 **Report-oriented** — keep a record of troubleshooting results.
- 🧩 **GUI + CLI** — different interfaces for different workflows.

### Known limitations

- No Windows hardware/GUI acceptance test completed.
- No signed installer, MSIX, or WinGet package.
- Long-running repairs may still block parts of the interface.
- PowerShell/CIM availability depends on Windows version and enterprise policies.
- Full report exports can include sensitive machine identifiers.

## 🛡️ Safety first / اول امنیت

| Safe to start with / مناسب برای شروع | Requires care / نیازمند احتیاط |
|---|---|
| System overview | SFC / DISM repair |
| Read-only network tests | Network stack reset |
| Storage capacity check | Filesystem repair |
| Event log review | Forced process termination |

**Never run unknown commands blindly. Never disable endpoint security to run this project.**

## 🗺️ Roadmap

- [x] Windows PowerShell-based toolkit prototype
- [x] GUI and CLI entry points in the v3 distribution
- [x] HTML and JSON report formats in the v3 distribution
- [x] Structural tests in the v3 distribution
- [ ] Publish and verify full v3 source in this repository
- [ ] Windows 10/11 GUI integration testing
- [ ] Full Persian RTL localization and accessibility review
- [ ] Background workers for every long-running repair
- [ ] Signed installer, release hashes and reproducible packaging
- [ ] CI on a Windows runner (or a documented local alternative)
- [ ] Release security review

## 🤝 Contributing

Bug reports, Windows compatibility results, and accessibility feedback are welcome. Please **redact IP addresses, usernames, machine names, and other private information** before posting logs.

## 🌱 Built by RISHEH

**RISHEH — Digital Products, Automation & Engineering**

Made with care, curiosity, and a healthy respect for the Restart button. 🔄

---

<div align="center">

**Fix the problem. Keep the evidence. Learn something.** ✨

**مشکل را پیدا کن، مستند کن، بعد اصلاح کن.**

</div>
