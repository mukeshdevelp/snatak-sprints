# React Intro

**Mukesh** edited this page on Dec 14, 2023 · 1 revision

| Author | Created on | Version | Last updated by | Last edited on |
|--------|------------|---------|-----------------|----------------|
| Mukesh | 10-08-23 | version 1 | Mukesh | 24-08-23 |

## Table of Contents

1. [Introduction](#1-introduction)
2. [Why React?](#2-why-react)
3. [What is React?](#3-what-is-react)
4. [Key Features](#4-key-features)
    
    4.1. [React 16 Specific Features](#41-react-16-specific-features)
    
    4.2. [Core React Features](#42-core-react-features)
5. [Getting Started](#5-getting-started)
    
    5.1. [Pre-requisites](#51-pre-requisites)
    
    5.2. [Installation](#52-installation)
    
    5.3. [Quick Start](#53-quick-start)
6. [Software Overview](#6-software-overview)
7. [Version Information](#7-version-information)
8. [Additional Resources](#8-additional-resources)

## 1. Introduction

React is a free and open-source JavaScript library for building user interfaces, particularly web applications. Developed and maintained by Facebook (now Meta), React 16 was released in September 2017 and introduced significant improvements over previous versions. React enables developers to create interactive, component-based UIs with a declarative programming paradigm, making it easier to build complex applications with predictable behavior and efficient rendering.

## 2. Why React?

React was created to solve several critical problems in web development:

- **Complex UI Management**: Traditional JavaScript applications become difficult to maintain as they grow. React's component-based architecture breaks down complex UIs into reusable, manageable pieces
- **Performance Issues**: Direct DOM manipulation is slow and inefficient. React's virtual DOM and reconciliation algorithm minimize expensive DOM operations, resulting in faster applications
- **State Management Complexity**: Managing application state across multiple components is challenging. React provides a unidirectional data flow that makes state changes predictable and easier to debug
- **Developer Experience**: React's declarative syntax makes code more readable and maintainable. Developers describe what the UI should look like, and React handles how to update it
- **Reusability**: Components can be composed and reused across different parts of an application, reducing code duplication and development time
- **Ecosystem and Community**: React has a massive ecosystem of libraries, tools, and community support, making it easier to find solutions and resources
- **Cross-Platform Development**: React can be used for web, mobile (React Native), and desktop applications, allowing code reuse across platforms
- **Industry Adoption**: Used by major companies like Facebook, Netflix, Airbnb, and many others, ensuring long-term support and stability

## 3. What is React?

React is a JavaScript library for building user interfaces. At its core, React is:

- **A Library, Not a Framework**: React focuses solely on the view layer of applications, allowing developers to choose other libraries for routing, state management, and other concerns
- **Component-Based**: Applications are built using reusable components that encapsulate their own structure, behavior, and styling
- **Declarative**: Developers describe what the UI should look like based on the current state, and React efficiently updates the DOM to match
- **Virtual DOM**: React maintains a lightweight representation of the DOM in memory (virtual DOM) and only updates the actual DOM when necessary, improving performance
- **Unidirectional Data Flow**: Data flows down from parent components to child components through props, making the application's behavior predictable
- **JavaScript Extension (JSX)**: React uses JSX, a syntax extension that allows writing HTML-like code in JavaScript, making component code more intuitive

## 4. Key Features

### 4.1. React 16 Specific Features

- **Fragments**: Introduced the ability to return multiple elements from a component without wrapping them in an extra DOM node using `React.Fragment` or shorthand `<>...</>`
- **Error Boundaries**: New component type that catches JavaScript errors anywhere in the child component tree, logs those errors, and displays a fallback UI instead of crashing the entire app
- **Portals**: Ability to render children into a DOM node that exists outside the parent component's DOM hierarchy, useful for modals, tooltips, and overlays
- **Improved Server-Side Rendering**: Better support for server-side rendering with `ReactDOMServer` improvements
- **New Lifecycle Methods**: Introduced `getDerivedStateFromProps` and `getSnapshotBeforeUpdate` for better control over component lifecycle
- **Context API**: Enhanced Context API (still experimental in React 16) for easier state sharing across component trees without prop drilling
- **Return Types**: Components can now return arrays, strings, numbers, and other types, not just a single React element
- **Reduced File Size**: React 16 is smaller than React 15, with the core library being approximately 30% smaller
- **Fiber Architecture**: Complete rewrite of React's reconciliation algorithm (React Fiber) for better performance, especially for large applications
- **Better Error Messages**: Improved error messages and stack traces for easier debugging

### 4.2. Core React Features

- **Components**: Reusable, self-contained pieces of UI that can be composed together
- **Props**: Immutable data passed from parent to child components
- **State**: Mutable data managed within a component that triggers re-renders when updated
- **Virtual DOM**: In-memory representation of the DOM that React uses to efficiently update the real DOM
- **JSX**: Syntax extension that allows writing HTML-like code in JavaScript
- **One-Way Data Binding**: Data flows in one direction (downward), making the application easier to understand and debug
- **Lifecycle Methods**: Hooks into different phases of a component's lifecycle (mounting, updating, unmounting)
- **Event Handling**: Synthetic events that provide a consistent API across different browsers
- **Conditional Rendering**: Ability to conditionally render components based on state or props
- **Lists and Keys**: Efficient rendering of lists with proper key management
- **Composition**: Ability to compose components together to build complex UIs
- **Performance Optimization**: Built-in optimization techniques like `shouldComponentUpdate`, `React.memo`, and `PureComponent`


## 5. Getting Started

### 5.1. Pre-requisites

Before learning React, you should have:

- **JavaScript Fundamentals**: Strong understanding of ES6+ features (arrow functions, destructuring, spread operator, modules, classes, promises)
- **HTML/CSS**: Basic knowledge of HTML structure and CSS styling
- **DOM Concepts**: Understanding of how the Document Object Model works
- **Node.js and npm**: Basic familiarity with Node.js and npm (Node Package Manager)
- **Command Line**: Comfortable using terminal/command line
- **Code Editor**: Familiarity with a code editor (VS Code recommended)

### 5.2. Installation

React 16 can be installed via npm or yarn:

```bash
# Using npm
npm install react@^16.0.0 react-dom@^16.0.0

# Using yarn
yarn add react@^16.0.0 react-dom@^16.0.0
```

### 5.3. Quick Start

The easiest way to get started with React 16 is using Create React App:

```bash
# Create a new React app
npx create-react-app my-app

# Navigate to the app directory
cd my-app

# Start the development server
npm start
```

## 6. Software Overview

| Software | Version |
|----------|---------|
| React | 16.x |
| React DOM | 16.x |
| Node.js | 10.x or higher (recommended) |
| npm | 6.x or higher (recommended) |

## 7. Version Information

React 16 was released in September 2017. Key versions in the React 16 series:

- **React 16.0** (September 2017): Initial release with Fragments, Error Boundaries, Portals
- **React 16.2** (November 2017): Fragment support improvements
- **React 16.3** (March 2018): New Context API, new lifecycle methods, `createRef` API
- **React 16.4** (May 2018): Pointer Events support, bug fixes
- **React 16.5** (September 2018): Profiler DevTools, better error handling
- **React 16.6** (October 2018): `React.memo`, `React.lazy`, `Suspense`, `getDerivedStateFromError`
- **React 16.7** (December 2018): Bug fixes
- **React 16.8** (February 2019): Hooks introduced (`useState`, `useEffect`, etc.)

## 8. Additional Resources

- [React Official Documentation](https://reactjs.org/docs/getting-started.html)
- [React 16 Release Notes](https://react.dev/blog/2017/09/26/react-v16.0.html)
- [React GitHub Repository](https://github.com/facebook/react)
- [React DevTools](https://chrome.google.com/webstore/detail/react-developer-tools/fmkadmapgofadopljbjfkapdkoienihi)
- [Create React App Documentation](https://create-react-app.dev/)


