// -fopenmp
void f1()
{
    char buf[141] = {0};
    boost::posix_time::ptime t0 = boost::posix_time::microsec_clock::universal_time();
    int64_t n = 1000;
    for (int64_t i = 0; i < n; i++)
    {
        bigbang::crypto::CryptoPowHash(buf,sizeof(buf));
    }
    auto res = (boost::posix_time::microsec_clock::universal_time() - t0).total_milliseconds();
    std::cout << "single thread milliseconds:" << res << std::endl << (n * 1000.0) / res << "H/s" << std::endl;
}

void f2()
{
    char buf[141] = {0};
    boost::posix_time::ptime t0 = boost::posix_time::microsec_clock::universal_time();
    int n = 1000;
    omp_set_num_threads(4);
    #pragma omp parallel for  
    for (int i = 0; i < n; i++)
    {
        bigbang::crypto::CryptoPowHash(buf,sizeof(buf));
    }
    auto res = (boost::posix_time::microsec_clock::universal_time() - t0).total_milliseconds();
    std::cout << "multit thread milliseconds:" << res << std::endl << (n * 1000.0) / res << "H/s" << std::endl;
}

// ----------gpu test---------
cuda_extra.cu 文件中增加如下代码：
if (-639249890 == *(int*)hash)
{
        uint32_t idx = atomicInc(d_res_count, 0xFFFFFFFF);
        if (idx < 10) {
            d_res_nonce[idx] = thread;
        }
}

const static uint8_t test_input[76] = {0};

void test()
{
    nvid_ctx ctx;
    ctx.module = nullptr;
    ctx.kernel = nullptr;
    ctx.kernel_variant = xmrig::VARIANT_2;
    ctx.kernel_height = 0;
    ctx.device_id = 0;
    ctx.device_blocks = 1;  //45;
    ctx.device_threads = 1; //44;
    ctx.device_bfactor = 0;
    ctx.device_bsleep = 0;
    ctx.syncMode = 3;
    uint32_t foundNonce[10];
    uint32_t foundCount;
    const xmrig::Algo algorithm = xmrig::Algo::CRYPTONIGHT;
    if (cuda_get_deviceinfo(&ctx, algorithm, false) != 0 || cryptonight_gpu_init(&ctx, algorithm) != 1)
    {
        printf("err");
        return;
    }
    uint32_t m_nonce = 0;
    xmrig::Variant v = xmrig::Variant::VARIANT_2;
    cryptonight_extra_cpu_set_data(&ctx, test_input, 76);
    cryptonight_extra_cpu_prepare(&ctx, m_nonce, algorithm, v);
    cryptonight_gpu_hash(&ctx, algorithm, v, (uint64_t)0, m_nonce);
    cryptonight_extra_cpu_final(&ctx, m_nonce, 0, &foundCount, foundNonce, algorithm, v);
    for (size_t i = 0; i < foundCount; i++)
    {
        assert(foundNonce[i] == 0);
        printf("ok(0):%d \n", foundNonce[i]);
    }
}

// ------------------CPU 测试  -------------
// CnHash.cpp 增加如下代码
#include "CnCtx.h"
static const xmrig::CnHash cnHash;
static struct cryptonight_ctx *ctx = nullptr;
void Test()
{

    const size_t max_mem_size = 4 * 1024 * 1024;
    xmrig::VirtualMemory mem(max_mem_size, true, 4096);
    xmrig::CnCtx::create(&ctx, mem.scratchpad(), max_mem_size, 1);
    const static uint8_t test_input[76] = {0};
    uint8_t output[32];
    cnHash.fn(xmrig::Algorithm::CN_2, xmrig::CnHash::AV_SINGLE, xmrig::Assembly::INTEL)(test_input, 76, output, &ctx, 0);
    assert(-639249890 == *(int *)output);
    printf("%d \n", *(int *)output);
}

// ---------slow 测试 -------
void Test()
{
	char hash[32];
	uint8_t buf[76] = { 0 };
	cn_slow_hash(buf, 76, hash, 2, 0, 0);
	if (-639249890 == *(int*)hash)
	{
		printf("OK\n");
	}
}

