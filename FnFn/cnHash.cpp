// cnHash.cpp 增加如下代码，就可以完成对性能的测试
#include "crypto/common/VirtualMemory.h"
#include "crypto/cn/CnCtx.h"
#include "CryptoNight_x86.h"
#include "crypto/common/Algorithm.h"

void TestHash()
{
    static const size_t max_mem_size = 4 * 1024 * 1024;
    static xmrig::VirtualMemory mem(max_mem_size, true, 4096);
    static cryptonight_ctx *ctx = nullptr;
    if (ctx == nullptr)
    {
        xmrig::CnCtx::create(&ctx, mem.scratchpad(), max_mem_size, 1);
    }
    uint8_t buf[141] = {0};
    uint8_t out[32] = {0};
    for (int i = 0; i < 100; i++)
    {
        buf[0] = rand() % 256;
        xmrig::cryptonight_single_hash<xmrig::Algorithm::CN_2, true>(buf, 141, out, &ctx, 0);
        printf("%d \n", (int)out[0]);
    }
}

// CUDA 
void Test()
{
    nvid_ctx m_ctx;
    m_ctx.module = nullptr;
    m_ctx.kernel = nullptr;
    m_ctx.kernel_variant = xmrig::VARIANT_2;
    m_ctx.kernel_height = 0;

    m_ctx.device_id = 0;       //static_cast<int>(thread->index());
    m_ctx.device_blocks = 45;  //thread->blocks();
    m_ctx.device_threads = 44; // thread->threads();
    m_ctx.device_bfactor = 0;  // thread->bfactor();
    m_ctx.device_bsleep = 0;   //thread->bsleep();
    m_ctx.syncMode = 3;        // thread->syncMode();

    if (cuda_get_deviceinfo(&m_ctx, xmrig::Algo::CRYPTONIGHT, false) != 0 || cryptonight_gpu_init(&m_ctx, xmrig::Algo::CRYPTONIGHT) != 1)
    {
        LOG_ERR("Setup failed for GPU %zu. Exitting.", 0);
        return;
    }
    uint8_t m_blob[128];
    cryptonight_extra_cpu_set_data(&m_ctx, m_blob, 76);

    uint32_t m_nonce = 0;
    uint32_t foundNonce[10];
    uint32_t foundCount = 10;
    uint64_t tar;
    cryptonight_extra_cpu_prepare(&m_ctx, m_nonce, xmrig::Algo::CRYPTONIGHT, xmrig::Variant::VARIANT_2);
    cryptonight_gpu_hash(&m_ctx, xmrig::Algo::CRYPTONIGHT, xmrig::Variant::VARIANT_2, 0, m_nonce);
    cryptonight_extra_cpu_final(&m_ctx, m_nonce, tar, &foundCount, foundNonce, xmrig::Algo::CRYPTONIGHT, xmrig::Variant::VARIANT_2);

    //for (size_t i = 0; i < foundCount; i++)
    //{
    //*m_job.nonce() = foundNonce[i];
    //Workers::submit(m_job);
    //}
    //m_count += m_ctx.device_blocks * m_ctx.device_threads;
    //m_nonce += m_ctx.device_blocks * m_ctx.device_threads;
}

