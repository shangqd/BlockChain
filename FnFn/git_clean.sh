git gc 
git verify-pack -v .git/objects/pack/pack-*.idx | sort -k 3 -g | tail -10 
2e0e720be6eddfdfd6aa91b1ec5e5f6ffb95393b blob 159228 12325 2091093 
8ccea79c4c0bd8330b56d852739a0d7909603fc7 blob 184320 38754 992767 
eeae00a9e10d7f1ab420c2e3a37dd20e9cd6f82b blob 185344 22571 1427037 
431805a77bcf3dbcd087c99d4141593facc49968 blob 204420 11392 2465625 
7eea796373e82d1b129256cf238f15d5cbbc363c blob 288888 37561 2128805 
9376adc1b0018bf1ff64b11a8f02a0a6b295b3b5 blob 393216 39897 1449793 
3fe87dceea77c8d970b2812f1e7d31665c13bf8a blob 409600 53371 939396 
5e8c43e4369665b9c57b57dd2f06da372a427582 blob 461824 48320 2192589 
2b0763efbce8111a8822a0920299e4f022e35107 blob 489901 33686 1594596 
e54f20da9cf3593f91e7bdba5cc88e958442e0d3 blob 2031616 60286 2241736 

git rev-list --objects --all | grep 431805a77bcf3dbcd087c99d4141593facc49968 
git log --pretty=oneline --branches -- vs2017/crypto/Debug/crypto.pch 
git log --pretty=oneline --branches -- vs2015/snappy/x64/Debug/snappy.idb 
git log --pretty=oneline --branches -- snappy/testdata/html_x_4 
git log --pretty=oneline --branches -- vs2017/.vs/BigBang/v15/ipch/a648ad9c4ea2d2df.ipch 
git filter-branch --force --index-filter 'git rm --cached --ignore-unmatch --ignore-unmatch vs2017/Debug/crypto.pch' --prune-empty --tag-name-filter cat -- --all 
git filter-branch --force --index-filter 'git rm --cached --ignore-unmatch --ignore-unmatch vs2015/snappy/x64/Debug/snappy.idb' --prune-empty --tag-name-filter cat -- --all 
git filter-branch --force --index-filter 'git rm --cached --ignore-unmatch --ignore-unmatch snappy/testdata/html_x_4' --prune-empty --tag-name-filter cat -- --all 
git filter-branch --force --index-filter 'git rm --cached --ignore-unmatch --ignore-unmatch vs2017/.vs/BigBang/v15/ipch/a648ad9c4ea2d2df.ipch' --prune-empty --tag-name-filter cat -- --all 
git log --pretty=oneline --branches -- vs2015/snappy/x64/Debug/snappy.pdb 
git filter-branch --force --index-filter 'git rm --cached --ignore-unmatch --ignore-unmatch vs2015/snappy/x64/Debug/snappy.pdb' --prune-empty --tag-name-filter cat -- --all 
git push --force 
rm -Rf .git/refs/original 
rm -Rf .git/logs/ 
git gc --prune=now 
# 在次提交 
git push --force 
