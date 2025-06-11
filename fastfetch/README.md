# 🚀 Fastfetch

Fastfetch is a modern system information tool that displays system information in a beautiful and customizable way. It's written in C and designed to be fast and efficient.

![Fastfetch Preview 1](preview1.png)
![Fastfetch Preview 2](preview2.png)

## ✨ Features

- ⚡ Fast and lightweight
- 🎨 Beautiful and customizable output
- 🖼️ Support for random system images
- ⚙️ Highly configurable
- 🌐 Cross-platform support

## 📦 Installation

1. Install Requerment Packages
```bash
sudo pacman -S fastfetch jq
```

2. Clone the repository:
```bash
cd .config
git clone https://github.com/yourusername/fastfetch.git
```

### ⚙️ Configuration

To enable the random image feature, add the following line to your shell configuration file:

For ZSH users:
```bash
echo '$HOME/.config/fastfetch/random-image.sh' >> ~/.zshrc
```

For Bash users:
```bash
echo '$HOME/.config/fastfetch/random-image.sh' >> ~/.bashrc
```

This will ensure that Fastfetch displays a random system image each time you open your terminal.

## 🚀 Usage

Simply open your terminal to display system information.

## 🔧 Configuration

Fastfetch can be configured by editing the configuration file located at `$HOME/.config/fastfetch/config-compact.jsonc`.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request Images or Any Improvments.

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.
