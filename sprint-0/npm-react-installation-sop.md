# React.js Installation SOP

## Prerequisites

### Check Node.js & npm
```bash
node --version
npm --version
```

### Install Node.js (if not installed)
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install nodejs npm

# macOS (with Homebrew)
brew install node
```

---

## Method 1: Create React App (Recommended)

### Step 1: Create React Project
```bash
npx create-react-app my-react-app
```

### Step 2: Navigate to Project
```bash
cd my-react-app
```

### Step 3: Start Development Server
```bash
npm start
```

**Result:** App opens at `http://localhost:3000`

---

## Method 2: Vite (Fast Alternative)

### Step 1: Create Project
```bash
npm create vite@latest my-react-app -- --template react
```

### Step 2: Navigate & Install
```bash
cd my-react-app
npm install
```

### Step 3: Start Development Server
```bash
npm run dev
```

---

## Quick Commands Reference

```bash
# Create React App
npx create-react-app project-name
cd project-name
npm start

# Vite
npm create vite@latest project-name -- --template react
cd project-name
npm install
npm run dev

# Stop Server
Ctrl + C
```

---

## Verify Installation

```bash
# Check React version
npm list react react-dom

# Check in package.json
cat package.json | grep react
```

