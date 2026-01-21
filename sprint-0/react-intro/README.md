# React Intro Documentation



| Author | Created on | Version | Last updated by | Last edited on | Pre Reviewer | L0 Reviewer | L1 Reviewer | L2 Reviewer |
|--------|------------|---------|-----------------|----------------|--------------|-------------|-------------|-------------|
| Mukesh Sharma | 16-01-2026 | v1.0 | Mukesh Sharma | 16-01-2026 |  |  |  |  |

## Table of Contents

- [What is React?](#what-is-react)
  - [Definition](#definition)
  - [Core Components](#core-components)
- [Why React?](#why-react)
  - [Benefits](#benefits)
  - [Use Cases](#use-cases)
- [Key Features](#key-features)
- [Important Concepts of React](#important-concepts-of-react)
- [Getting Started](#getting-started)
  - [Pre-requisites](#pre-requisites)
  - [Create React App with Vite](#create-react-app-with-vite)
- [Software Overview](#software-overview)
- [System Requirements](#system-requirements)
- [Dependencies](#dependencies)
  - [Run-time Dependency](#run-time-dependency)
  - [Development Dependency](#development-dependency)
- [Conclusion](#conclusion)
- [Troubleshooting](#troubleshooting)
- [FAQs](#faqs)
- [Contact Information](#contact-information)
- [References](#references)

## What is React?

React is a free and open-source JavaScript library for building user interfaces, particularly web applications. Developed and maintained by Facebook (now Meta), React enables developers to create interactive, component-based UIs with a declarative programming paradigm, making it easier to build complex applications with predictable behavior and efficient rendering.

### Definition

React is a JavaScript library for building user interfaces. It focuses solely on the view layer of applications, allowing developers to create reusable UI components that can be composed together to build complex user interfaces. React uses a virtual DOM to efficiently update the actual DOM, resulting in high-performance applications.

### Core Components

1. **React Core Library**: The main React library containing component logic and virtual DOM implementation
2. **React DOM**: Library for rendering React components to the DOM
3. **JSX (JavaScript XML)**: Syntax extension that allows writing HTML-like code in JavaScript
4. **Component System**: Reusable, self-contained pieces of UI that encapsulate structure, behavior, and styling
5. **Virtual DOM**: Lightweight representation of the DOM in memory for efficient updates

## Why React?

React was created to solve several critical problems in web development and has become one of the most popular JavaScript libraries for building user interfaces.

### Benefits

1. **Component-Based Architecture**: Reusable, manageable pieces reducing code duplication
2. **Virtual DOM Performance**: Efficient diffing algorithms for faster applications
3. **Declarative Syntax**: Describe UI appearance, React handles updates
4. **Unidirectional Data Flow**: Predictable data flow from parent to child
5. **Large Ecosystem**: Extensive libraries, tools, and community support
6. **Cross-Platform**: Web (React), mobile (React Native), desktop applications
7. **Industry Adoption**: Used by Facebook, Netflix, Airbnb ensuring long-term support
8. **Developer Tools**: React DevTools, hot reloading, comprehensive debugging

### Use Cases

React is used in various scenarios: Single Page Applications (SPAs), complex user interfaces, e-commerce platforms, social media applications, dashboard applications, mobile applications (via React Native), and Progressive Web Apps (PWAs).

## Key Features

1. **Component-Based Architecture**: Reusable, self-contained components that can be composed together
2. **Virtual DOM**: Efficient DOM updates through in-memory representation and diffing algorithm
3. **JSX Syntax**: HTML-like syntax in JavaScript for intuitive component development
4. **Unidirectional Data Flow**: Predictable data flow from parent to child components via props
5. **State Management**: Built-in state management with hooks and class component state
6. **Lifecycle Methods**: Hooks into component lifecycle phases (mounting, updating, unmounting)
7. **Event Handling**: Synthetic events providing consistent API across browsers
8. **Server-Side Rendering**: Support for rendering React components on the server for improved performance

## Important Concepts of React

### React Project Folder Structure

```
my-react-app/
├── public/
│   ├── index.html
│   ├── favicon.ico
│   └── manifest.json
├── src/                  # dev code goes here, like components
│   ├── components/
│   │   ├── Header.js
│   │   ├── Footer.js
│   │   └── Button.js
│   ├── hooks/
│   │   └── useCustomHook.js
│   ├── context/
│   │   └── AppContext.js
│   ├── App.js
│   ├── App.css
│   ├── index.js
│   └── index.css
├── package.json
├── package-lock.json
└── README.md
```

### 1. Components

Reusable, self-contained pieces of UI. Can be functional (using hooks) or class-based.

```javascript
// Functional Component
function Welcome(props) {
  return <h1>Hello, {props.name}!</h1>;
}

// Class Component
class Welcome extends React.Component {
  render() {
    return <h1>Hello, {this.props.name}!</h1>;
  }
}
```

### 2. JSX (JavaScript XML)

Syntax extension allowing HTML-like code in JavaScript.

```javascript
function App() {
  const name = "React";
  return (
    <div className="app">
      <h1>Hello, {name}!</h1>
      <p>Welcome to React</p>
    </div>
  );
}
```

### 3. Props (Properties)

Immutable data passed from parent to child components.

```javascript
// Child component receiving props
function Greeting({ userName, role }) {
  return (
    <div>
      <h1>Welcome, {userName}!</h1>
      <p>Role: {role}</p>
    </div>
  );
}

// Parent component passing props to the child
function App() {
  return <Greeting userName="John" role="Developer" />;
}
```

### 4. State Management

Mutable data managed within a component that triggers re-renders. Modern React uses hooks like `useState`.

```javascript
// src/components/Counter.js
import React, { useState } from 'react';

function Counter() {
  const [count, setCount] = useState(0);
  
  return (
    <div>
      <p>Count: {count}</p>
      <button onClick={() => setCount(count + 1)}>Increment</button>
      <button onClick={() => setCount(count - 1)}>Decrement</button>
    </div>
  );
}

export default Counter;
```

### 5. Hooks

Functions enabling state and React features in functional components.

```javascript
import { useState, useEffect } from 'react';

function UserProfile({ userId }) {
  const [user, setUser] = useState(null);
  
  useEffect(() => {
    fetch(`/api/users/${userId}`)
      .then(res => res.json())
      .then(data => setUser(data));
  }, [userId]);
  
  return user ? <div>{user.name}</div> : <div>Loading...</div>;
}
```

### 6. Virtual DOM

In-memory representation of the DOM for efficient updates. React compares virtual DOM trees and only updates changed elements.

```javascript
function TodoList({ todos }) {
  return (
    <ul>
      {todos.map(todo => (
        <li key={todo.id}>{todo.text}</li>
      ))}
    </ul>
  );
}
```

### 7. Reconciliation Algorithm

React's diffing algorithm determining the most efficient way to update the DOM when state or props change.

### 8. Error Boundaries

Components that catch JavaScript errors and display fallback UI.

```javascript
class ErrorBoundary extends React.Component {
  state = { hasError: false };
  
  static getDerivedStateFromError(error) {
    return { hasError: true };
  }
  
  render() {
    return this.state.hasError 
      ? <h1>Something went wrong.</h1>
      : this.props.children;
  }
}
```

### 9. Context API

Built-in state management for sharing data without prop drilling.

```javascript
const ThemeContext = createContext();

export function ThemeProvider({ children }) {
  const [theme, setTheme] = useState('light');
  return (
    <ThemeContext.Provider value={{ theme, setTheme }}>
      {children}
    </ThemeContext.Provider>
  );
}

// Usage
function ThemedButton() {
  const { theme, setTheme } = useContext(ThemeContext);
  return <button onClick={() => setTheme(theme === 'light' ? 'dark' : 'light')}>
    Theme: {theme}
  </button>;
}
```

### 10. Fragments

Return multiple elements without extra DOM wrapper.

```javascript
function List() {
  return (
    <>
      <Header />
      <Content />
      <Footer />
    </>
  );
}
```

## Getting Started

### Pre-requisites

| Requirement | Description |
|-------------|-------------|
| JavaScript Fundamentals | ES6+ features (arrow functions, destructuring, modules, classes, promises) |
| HTML/CSS | Basic HTML structure and CSS styling |
| DOM Concepts | Understanding of Document Object Model |
| Node.js and npm | Basic familiarity with Node.js and npm |
| Command Line | Comfortable using terminal/command line |
| Code Editor | VS Code recommended |

### Create React App with Vite

```bash
# Using npm
npm create vite@latest my-react-app -- --template react

# Using yarn
yarn create vite my-react-app --template react

# Using pnpm
pnpm create vite my-react-app --template react
```

Then:

```bash
cd my-react-app
npm install        # or: yarn install / pnpm install
npm run dev        # or: yarn dev / pnpm dev
```

Open the printed URL (usually http://localhost:5173) in your browser.

## Software Overview

| Software | Version |
|----------|---------|
| React | 18.x (latest stable) |
| React DOM | 18.x |
| Node.js | 16.x or higher (recommended) |
| npm | 8.x or higher (recommended) |

## System Requirements

| Requirement | Minimum | Recommendation |
|-------------|---------|----------------|
| Node.js | 14.x | 16.x or higher |
| npm | 6.x | 8.x or higher |
| RAM | 4 GB | 8 GB or higher |
| Disk Space | 500 MB | 1 GB or higher |
| Browser | Modern browser | Latest version |

## Dependencies

### Run-time Dependency

| Run-time Dependency | Version | Description |
|---------------------|---------|-------------|
| react | ^18.0.0 | Core React library for building user interfaces |
| react-dom | ^18.0.0 | React library for DOM rendering and manipulation |

### Development Dependency

| Development Dependency | Version | Description |
|----------------------|---------|-------------|
| react-scripts | ^5.0.0 | Scripts and configuration used by Create React App |
| @babel/core | ^7.0.0 | JavaScript compiler for transforming JSX and ES6+ code |
| webpack | ^5.0.0 | Module bundler for packaging React applications |

## Conclusion

React is a powerful, versatile JavaScript library for building user interfaces. With component-based architecture, virtual DOM, and extensive ecosystem, React has become the industry standard for modern web development across web, mobile, and desktop platforms.

## Troubleshooting

**npm install fails:** `npm cache clean --force`, delete `node_modules` and `package-lock.json`, then `npm install`.

**Port 3000 in use:** Kill process or use `PORT=3001 npm start`.

**Build fails:** Install dependencies with `npm install` and ensure `.babelrc` includes `@babel/preset-react` (or use Create React App).

## FAQs

**1. Is React a framework or a library?**

React is a library focusing on the view layer.

**2. What is the difference between React and React Native?**

React is for web, React Native for mobile applications.

**3. Do I need to learn JavaScript before React?**

Yes, strong understanding of JavaScript (ES6+) is essential.

**4. What is JSX?**

JSX is a syntax extension allowing HTML-like code in JavaScript.

**5. What are React Hooks?**

Functions enabling state and React features in functional components (React 16.8+).

**6. What is the Virtual DOM?**

In-memory representation of the DOM for efficient updates.

**7. Can I use React without Node.js?**

Node.js required for development. Production apps can be static files.

**8. What is the difference between props and state?**

Props are immutable data from parent. State is mutable data within component.

**9. Is React free to use?**

Yes, React is free and open-source (MIT license).

## Contact Information

| Name | Email address |
|------|---------------|
| Mukesh | msmukeshkumarsharma@gmail.com |

## References

| Links | Descriptions |
|-------|--------------|
| https://react.dev/ | Official React documentation |
| https://react.dev/learn | React interactive tutorial |
| https://github.com/facebook/react | React GitHub repository |
| https://create-react-app.dev/ | Create React App documentation |

