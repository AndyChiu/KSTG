// 鍵帽儲存托盤產生器
// Keycap Storage Tray Generator
include <KSTG_Base.SCAD>

// 可複製此樣板檔依照自己需求另存新檔
// 以便以檔案區隔樣式

// 鍵帽名稱: xxx 鍵帽
// 外盒名稱: xxx 包裝盒


// 存放盒子的大小:
BoxSize_L1 = 190; //長度(水平)
BoxSize_W1 = 120; //寬度(垂直)
BoxSize_H1 = 55;  //高度

// 外圍厚度
Tray_Fence_T = 1;  //厚度
Tray_Fence_H = 5;  //高度

//放置鍵帽空間
Keycaps_Space_L = 18.5;
Keycaps_Space_W = 17.5;

// 分隔片
Tray_Separator_T_L = 1;  //厚度(長;水平) 
Tray_Separator_T_W = 2;  //厚度(寬;垂直)
Tray_Separator_H = 2;  //高度 建議高於上一層與此層鍵帽間的空隙,避免運輸時鍵帽脫落跑到其他空間
Tray_Separator_L = 3;  //短隔板長度

// 分隔片(長寬區分/尚未使用)
//Tray_Separator_H_L = 5;  //長(水平) 高度
//Tray_Separator_H_W = 5;  //寬(垂直) 高度

// 底板 分隔板往中心延伸的底板
// 如果給Stem突出的鍵帽,計算出的"中央開口"孔徑要大於特定尺寸才能正常插入,厚度值則要足夠才不會接觸到下層鍵帽,例如iRock矮鍵帽需5.5mm厚度3.5mm、Kailh Choc矮軸鍵帽需7mm厚度2mm,如開口不夠大請調整 Tray_Bottom_L 參數
Tray_Bottom_L = (Keycaps_Space_W-8)/2; //水平底板寬度
Tray_Bottom_W = (Keycaps_Space_L-12)/2; //垂直底板寬度
Tray_Bottom_T = 2; //底板厚度

//常見鍵帽高度表(最高的鍵帽）:
//MX:
//SA      16.5mm
//Cherry   9.4mm
//OEM     11.9mm
//TAI HAO 14.8mm
//XDA 9.1mm  
//DSA 7.6mm
//ADA   8mm (18.2x18.2mm )
//MA  8.8mm (18.3x18.3mm)
//Choc V1:
//Kailh 3.3mm (+2mm stem)
//適用於 Tray_Column_H 參數

//四角落立柱高度
//堆疊托盤時可墊高避免直接碰觸鍵帽
Tray_Column_H = 8.5; // 高度 可依照鍵帽高度調整
Tray_Column_T = 2;  // 厚度
Tray_Column_L = 15; // 長面長度
Tray_Column_W = 15; // 寬面長度 

//垂直分隔片樣式
// 0 不需要
// 1 全部
// 2 短隔板無垂直底板
// 3 短隔板有垂直底板
// 4 無隔板有垂直底板

Tray_VS_Type = 1;

//多餘空間處理方式
//How to use the extra space
// 0 不處理，照原本盒子大小產生外圍
// 1 不處理，僅列印鍵帽所需空間
// 2 角落填補剩餘空間
ExtraSpaceUse = 2;

//填補空間高度
ES_H = Tray_Separator_H + Tray_Bottom_T; 
//ES_H = Tray_Column_H + Tray_Column_T;

//分隔片與底板

//是否於預覽狀態(F5)顯示座標數值標記 0關/1開
ShowText = 1 ;
//請參考F5後帶出的座標數值
//例如：
// Tray_Separator_Cut_L=[
// [1,1],[2,1],[3,1],[1,2]
// ];

//清除分隔片與底板

// 長(水平)分隔片 紅色
Tray_Separator_Cut_L=[
[4,1],[4,3]
];
// 寬(垂直)分隔片 藍色,     
Tray_Separator_Cut_W=[
[1,1]
];
// 交錯點 綠色 長寬分隔片交會處
// 須手動清除交錯點
Tray_Separator_Cut_C=[

];
// 長(水平)底板 紅色
Tray_Separator_Cut_LB=[
[4,1],[4,3]
];
// 寬(垂直)底板 藍色
Tray_Separator_Cut_WB=[
[1,1]
];

// 長(水平)底板 僅上方 紅色
Tray_Separator_Cut_LBU=[
[4,0],[4,2]
];

// 長(水平)底板 僅下方 紅色
Tray_Separator_Cut_LBD=[
[4,4],[4,2]
];

//增加分隔片與底板

// 長(水平)分隔片 紅色
Tray_Separator_Put_L=[
];
// 寬(垂直)分隔片 藍色     
Tray_Separator_Put_W=[
];
// 交錯點 綠色 長寬分隔片交會處
Tray_Separator_Put_C=[
];
// 長(水平)底板 紅色
Tray_Separator_Put_LB=[
];
// 寬(垂直)底板 藍色
Tray_Separator_Put_WB=[
];


CreateKST();