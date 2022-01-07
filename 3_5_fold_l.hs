-- Правая свертка брала список, помещала инициализирующее значение в самый конец
-- и начиная с правой стороны группировала элеменнты с помощью сворачивающей функции
-- Левая свертка является симметричной конструкцией!

-- Отличия в типах
-- foldr :: (a -> b -> b) -> b -> [a] -> b
-- foldl :: (b -> a -> b) -> b -> [a] -> b - элементы списка на втором месте 

-- Задача на отличие сверток
-- При каком значении переменной x следующие два выражения примут одно и то же значение 
-- (отличное от неопределенного)?

foldr (-) x [2,1,5]
foldl (-) x [2,1,5]

-- *Main> [foldr (-) (x) [2,1,5] | x <- [1..20]]
-- [5, 4, 3, 2, 1, 0,-1,-2,-3,-4,-5,-6,-7,-8,-9,-10,-11,-12,-13,-14]

-- *Main> [foldl (-) (x) [2,1,5] | x <- [1..20]]
-- [-7,-6,-5,-4,-3,-2,-1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]

-- 7-е значение, ответ 7

-- Реализация левой свертки

foldl :: (b -> a -> b) -> b -> [a] -> b
foldl f ini []      = ini                   -- сворачивающая функция f, инициализирующее значение и список
                                            -- на пустом списке возвращаем значение, также как для правой 
foldl f ini (x:xs)  = foldl f (f ini x) xs  -- рекурсивный вызов левой свертки происходит сразу же

-- foldl f ini 1:2:3:[] -- запись списка через конструкторы

-- Алгоритм
-- foldl f ini 1:2:3:[] -- запись списка через конструкторы
-- -> foldl f (f ini 1) (2:3:[])
-- -> foldl f (f ( f ini 1) 2) (3:[])
-- -> foldl f (f ( f (f ini 1) 2) 3) []
-- -> f (f (f ini 1) 2) 3

-- перепишем функцию в более строгом виде

foldl :: (b -> a -> b) -> b -> [a] -> b
foldl f ini []      = ini   
foldl f ini (x:xs)  = foldl f ini' xs
    where ini' = f ini x            -- это позволяет форсировать вычисление ini'
                                    -- и позволяет избежать отложенных вычислений  

-- функция левой свертки foldl' в строгом виде реализована в модуле Data.List

foldl'              :: (b -> a -> b) -> b -> [a] -> b
foldl' f ini []     = ini 
foldl' f ini (x:xs)  = ini' `seq` foldl' f ini' xs      -- форсируем ini' с 
    where ini' = f ini xs                               -- помощью seq