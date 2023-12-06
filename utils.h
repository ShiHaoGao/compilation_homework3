//
// Created by Gao Shihao on 2023/12/1.
//

#ifndef UTILS_H
#define UTILS_H

#include <iostream>
#include <llvm/Support/raw_ostream.h>

#define Info Log(LogLevel::info)
#define Warning Log(LogLevel::warning)
#define Debug Log(LogLevel::debug)
#define Error Log(LogLevel::error)

enum class LogLevel {
    info = 0,
    debug,
    warning,
    error
};

class Log {
public:
    explicit Log(LogLevel level) : _level(level) {}

    ~Log() {
        output();
    }

    Log &operator<<(const std::string &message) {
        _message += message;
        return *this;
    }

    Log &operator<<(const int &message) {
        _message += std::to_string(message);
        return *this;
    }

private:
    LogLevel _level;
    std::string _message;

    void output();
};

void Log::output() {
    if (_level == LogLevel::info) {
        std::cout << "\033[32m[Info]: " << _message << "\033[0m ";
    } else if (_level == LogLevel::warning) {
        std::cout << "\033[35m[Warning]: " << _message << "\033[0m ";
    } else if (_level == LogLevel::error) {
        std::cout << "\033[31m[Error]: " << _message << "\033[0m ";
    } else {
        std::cout << "\033[34m[Debug]: " << _message << "\033[0m ";
    }
}

#endif //UTILS_H
