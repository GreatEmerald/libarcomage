-- CardPools
-- This is the index file that points to the different card pools a user can have
-- GreatEmerald, 2011

-- GE: Mods will have more folders. To activate them, add a line like these pointing to their CardPools.
dofile('lua/Arcomage/CardPool.lua');
dofile('lua/MArcomage/MArcomagePool.lua');

PoolInfo = { {Name = "Arcomage", InitFunction = "ArcomageInit"}, {Name = "MArcomage", InitFunction = "MA_Init"} }
PoolSize = #PoolInfo
