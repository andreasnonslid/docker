#!/bin/bash

# Function to build the image
build_image() {
    TOOLCHAIN_ARG=$1
    if [ "$TOOLCHAIN_ARG" = "gnu" ] || [ "$TOOLCHAIN_ARG" = "g" ]; then
        echo "Building GNU toolchain image..."
        docker build --build-arg TOOLCHAIN=gnu -t my-gnu-toolchain .
    elif [ "$TOOLCHAIN_ARG" = "llvm" ] || [ "$TOOLCHAIN_ARG" = "l" ]; then
        echo "Building LLVM toolchain image..."
        docker build --build-arg TOOLCHAIN=llvm -t my-llvm-toolchain .
    else
        echo "Invalid toolchain specified. Please choose 'gnu' (or 'g') or 'llvm' (or 'l')."
        exit 1
    fi
}

# Function to run the image
run_image() {
    TOOLCHAIN_ARG=$1
    if [ "$TOOLCHAIN_ARG" = "gnu" ] || [ "$TOOLCHAIN_ARG" = "g" ]; then
        echo "Running GNU toolchain image..."
        docker run -it my-gnu-toolchain
    elif [ "$TOOLCHAIN_ARG" = "llvm" ] || [ "$TOOLCHAIN_ARG" = "l" ]; then
        echo "Running LLVM toolchain image..."
        docker run -it my-llvm-toolchain
    else
        echo "Invalid toolchain specified. Please choose 'gnu' (or 'g') or 'llvm' (or 'l')."
        exit 1
    fi
}

# Main logic
if [ "$#" -eq 0 ]; then
    # No arguments provided, ask the user
    read -p "Would you like to build or run the image? (build/run or b/r): " ACTION
    ACTION=$(echo "$ACTION" | tr '[:upper:]' '[:lower:]')
    if [ "$ACTION" = "b" ]; then ACTION="build"; fi
    if [ "$ACTION" = "r" ]; then ACTION="run"; fi

    if [ "$ACTION" != "build" ] && [ "$ACTION" != "run" ]; then
        echo "Invalid action specified. Please choose 'build' (or 'b') or 'run' (or 'r')."
        exit 1
    fi

    read -p "Which version would you like to use? (gnu/llvm or g/l): " TOOLCHAIN
    TOOLCHAIN=$(echo "$TOOLCHAIN" | tr '[:upper:]' '[:lower:]')
    if [ "$TOOLCHAIN" = "g" ]; then TOOLCHAIN="gnu"; fi
    if [ "$TOOLCHAIN" = "l" ]; then TOOLCHAIN="llvm"; fi

    if [ "$TOOLCHAIN" != "gnu" ] && [ "$TOOLCHAIN" != "llvm" ]; then
        echo "Invalid toolchain specified. Please choose 'gnu' (or 'g') or 'llvm' (or 'l')."
        exit 1
    fi

    if [ "$ACTION" = "build" ]; then
        build_image "$TOOLCHAIN"
    else
        run_image "$TOOLCHAIN"
    fi
elif [ "$#" -eq 2 ]; then
    # Arguments provided, process them
    ACTION=$(echo "$1" | tr '[:upper:]' '[:lower:]')
    TOOLCHAIN=$(echo "$2" | tr '[:upper:]' '[:lower:]')

    if [ "$ACTION" = "b" ]; then ACTION="build"; fi
    if [ "$ACTION" = "r" ]; then ACTION="run"; fi

    if [ "$TOOLCHAIN" = "g" ]; then TOOLCHAIN="gnu"; fi
    if [ "$TOOLCHAIN" = "l" ]; then TOOLCHAIN="llvm"; fi

    if [ "$ACTION" = "build" ]; then
        build_image "$TOOLCHAIN"
    elif [ "$ACTION" = "run" ]; then
        run_image "$TOOLCHAIN"
    else
        echo "Invalid action specified. Please choose 'build' (or 'b') or 'run' (or 'r')."
        exit 1
    fi
else
    echo "Usage: $0 [build|run or b|r] [gnu|llvm or g|l]"
    exit 1
fi
