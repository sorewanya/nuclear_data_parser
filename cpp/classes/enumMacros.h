// Макрос для объявления enum и массива строк
#define DECLARE_ENUM(EnumName, ...)                         \
    enum class EnumName                                     \
    {                                                       \
        __VA_ARGS__                                         \
    };                                                      \
    const std::string EnumName##Strings[] = {#__VA_ARGS__}; \
    std::string EnumName##ToString(EnumName value)          \
    {                                                       \
        return EnumName##Strings[static_cast<int>(value)];  \
    }