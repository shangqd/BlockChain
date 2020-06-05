
#include <vector>

class CBbBasicConfig
{
public:
	CBbBasicConfig();
	virtual ~CBbBasicConfig();
	static bool PostLoad();
};

template <typename... U>
class CCombinConfig
    : virtual public std::enable_if<std::is_base_of<CBbBasicConfig, U>::value,
                                    U>::type...
{
public:
    CCombinConfig() {}
    virtual ~CCombinConfig() {}

    virtual bool PostLoad()
    {
        std::vector<bool> v = {CBbBasicConfig::PostLoad(),U::PostLoad()...};
        return std::find(v.begin(), v.end(), false) == v.end();
    }
};

template <>
class CCombinConfig<> : virtual public CCombinConfig<CBbBasicConfig>
{
};