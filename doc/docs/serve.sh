#!/bin/bash

# SF CLI Documentation Server
# This script serves the Docsify documentation locally

echo "🚀 Starting SF CLI Documentation Server..."
echo ""

# Check if docsify-cli is installed
if ! command -v docsify &> /dev/null; then
    echo "❌ docsify-cli is not installed."
    echo "📦 Installing docsify-cli globally..."
    npm install -g docsify-cli
    echo "✅ docsify-cli installed successfully!"
    echo ""
fi

# Get the directory of this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

echo "📁 Serving documentation from: $SCRIPT_DIR"
echo "🌐 Opening browser at: http://localhost:3000"
echo ""
echo "📖 Documentation includes:"
echo "   • Installation Guide"
echo "   • Quick Start Tutorial"
echo "   • Complete Command Reference"
echo "   • Examples & Tutorials"
echo "   • Architecture Guide"
echo "   • Configuration Documentation"
echo "   • API Reference"
echo "   • Contributing Guidelines"
echo ""
echo "🛑 Press Ctrl+C to stop the server"
echo ""

# Serve the documentation
docsify serve "$SCRIPT_DIR" --port 3000 --open
