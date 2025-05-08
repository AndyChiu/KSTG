include <KSTG_Base.SCAD>

/*
====================================
  鍵帽儲存托盤產生器(KSTG)-設定檔
  KSTG - Configuration
====================================

(可複製此樣板檔
依照自己需求另存新檔
以便以檔案區隔樣式設定)

(You may copy this template file
and save it with a new name
to create a configuration variant by file)

 鍵帽名稱: xxx 鍵帽
 外盒名稱: xxx 包裝盒
 外盒尺寸: L x W x H mm

 Keycap name: xxx keycap
 Box name: xxx packaging box
 Box dimensions: L x W x H mm
  
*/

//=====================
// 存放盒子的內部存放空間設定:
// Internal storage space dimensions of the box:
//=====================
BoxSize_L1 = 137; //Length 長度(水平;x軸) row 
BoxSize_W1 = 147; //Width  寬度(垂直;y軸) col
BoxSize_H1 = 49.5;  //Height 高度

//=====================
// 鍵帽存放空間設定:
// Keycap storage space settings:
//=====================

// 放置1U鍵帽空間
// Space for placing 1U keycaps
Keycaps_Space_L = 18.5+2; //水平長度 (horizontal)
Keycaps_Space_W = 17.5+2; //垂直長度 (vertical) 

// 分隔鍵帽的分隔板設定：
// Divider settings between keycaps:

//厚度 Thickness
Tray_Separator_T_L = 0.5; //長;水平;x;row (length; horizontal)
Tray_Separator_T_W = 0.5; //寬;垂直;y;col (width; vertical)
//高度 Height
Tray_Separator_H_L = 4; //長;水平;x;row (length; horizontal)
Tray_Separator_H_W = 4; //寬;垂直;y;col(width; vertical)

//建議高度設定，高於托盤堆放時，鍵帽與上層托盤的空隙
//以避免運輸時鍵帽脫落
// Recommended height to maintain a gap between the keycaps and the upper tray during stacking,
// to prevent keycaps from falling out during transport

Tray_Separator_L = 3;  //短隔板長度 Short divider length

/*垂直分隔板樣式
 0 不需要
 1 全部
 2 短隔板無垂直底板
 3 短隔板有垂直底板
 4 無隔板有垂直底板 
 
 Vertical divider styles:
 0 Not needed
 1 All
 2 Short divider without vertical base
 3 Short divider with vertical base
 4 No dividers, only vertical base

*/

 Tray_VS_Type = 1;

/*
============================
 底板寬度-分隔板往中心延伸的底板
 Bottom Plate Width - Divider extending toward the center
============================
如果給Stem突出的鍵帽,計算出的"中央開口"孔徑要大於特定尺寸才能正常插入,
厚度值則要足夠才不會接觸到下層鍵帽,例如:
  iRock矮鍵帽需5.5mm厚度3.5mm
  Kailh Choc矮軸鍵帽需7mm厚度2mm
如開口不夠大請調整 Tray_Bottom_L 參數

For keycaps with protruding stems, the calculated "center opening" must be larger than a specific size for proper insertion.
he thickness must also be sufficient to avoid contact with the keycaps on the lower tray. For example:
    iRock low-profile keycaps require a 5.5mm opening and 3.5mm thickness
    Kailh Choc low-profile keycaps require a 7mm opening and 2mm thickness
If the opening is too small, please adjust the Tray_Bottom_L parameter.

*/
//底板寬度 Bottom plate width
Tray_Bottom_L = (Keycaps_Space_W- 8)/2; //(水平;x;row) Bottom plate width (horizontal)
Tray_Bottom_W = (Keycaps_Space_L-12)/2; //(垂直;y;col) (vertical)

Tray_Bottom_T = 2; //底板厚度 Bottom plate thickness

//=====================
// 托盤外觀設定:
// Tray Appearance Settings
//=====================

// 外圍 Fence
Tray_Fence_T = 1;  //厚度 Thickness
Tray_Fence_H = 5;  //高度 Height

/* 多餘空間處理方式
   How to use the extra space:
   0 不處理，照原本盒子大小產生外圍
     0 - No processing; generate tray outer frame based on original box size
   1 不處理，僅列印鍵帽所需空間
     1 - No processing; print only the space required for keycaps
   2 角落填補剩餘空間
     2 - Fill the remaining space in the corners
*/
ExtraSpaceUse = 2;

//填補空間高度
ES_H = 3;  // Height of the filled space

//延伸長度
ES_WE = 10; // Width-wise extension length
ES_LE = 10; // Length-wise extension length

/*
====================================
  四角落 立柱高度
  Corner Pillar Height
====================================
堆疊托盤時可墊高避免直接碰觸鍵帽
Used to elevate stacked trays to prevent direct contact with keycaps

適用於 Tray_Column_H 參數：
Applies to the Tray_Column_H parameter:

常見鍵帽高度表(最高的鍵帽）:
Typical maximum keycap heights:

MX:
SA      16.5mm
Cherry   9.4mm
OEM     11.9mm
TAI HAO 14.8mm
XDA  9.1mm  
DSA  7.6mm
ADA    8mm (18.2x18.2mm )
MA   8.8mm (18.3x18.3mm)
OSA 14.4mm
CSA 12.5mm
ASA 11.8mm

Choc V1:
Kailh 3.3mm (+2mm stem)

*/
Tray_Column_H = 10; // 高度 可依照鍵帽高度調整 // Height – can be adjusted based on keycap height
Tray_Column_T = 2;   // 厚度 Thickness
Tray_Column_L = 15;  // 長面長度 (水平;x;row) Long side length (horizontal; x; row)
Tray_Column_W = 15;  // 寬面長度 (垂直;y;col) Wide side length (vertical; y; col)

/*
====================================
  四角落 托盤固定槽榫 (Fixed Slot Tenon)
  Corner Tray Fixed Slot Tenon
====================================

堆疊時用於固定托盤
Used to secure trays when stacked

需要填補空間，需注意是否超過邊界
Requires filling extra space — make sure it doesn’t exceed the tray boundary
*/

// 是否啟用固定槽榫？
// Enable fixed slot tenon?
Tray_Corner_FST = true;

/*
1.外圍外側：不同盤鍵帽尺寸有變化時，放置位置會改變
   Outer edge of outer frame – changes if keycap layout differs across trays
2.外圍內側：不同盤鍵帽尺寸有變化時，放置位置會改變，但較省空間
   Inner edge of outer frame – changes with layout, more space-efficient
3.盒子邊緣：不同盤鍵帽尺寸有變化時，只要盒子尺寸相同就沒問題
   Box edge – placement remains consistent if outer box size is the same
*/

Tray_Corner_FST_Type = 3;

// 不須凸起的卡榫，可用於產生裝箱時最上層的托盤
// Use a flush (non-protruding) slot – useful for topmost tray when packing

Tray_Corner_FST_NoTenon = false;

// 屬性 Attributes:
Tray_Corner_FST_HA = 0;    // 高度增減，可依需求調整 // Height adjustment – customize as needed
Tray_Corner_FST_D = 45;    // 斜切角度 // Chamfer angle
Tray_Corner_FST_L = 5;     // 長面長度 // Long side length
Tray_Corner_FST_W = 5;     // 寬面長度，長寬建議相同 // Wide side length (suggest keeping width = length)
Tray_Corner_FST_S = 0.4;   // 榫縮尺寸 // Tenon shrink offset
Tray_Corner_FST_TH = 3;    // 榫頭高度 // Tenon head height

/*
====================================
  鍵帽存放空間全部移除與增加項目
  (目前用於Choc V1托盤)
  Remove and Add Items for Keycap Storage Space
  (Currently used for Choc V1 tray)
====================================
*/
// 全部區塊中央底板 移除物件 
// Remove objects from the center base of all blocks
Do_All_Block_Center_Cut=false;
Do_All_Block_Center_Cut_No_LastRow=true;
Do_All_Block_Center_Cut_No_LastCol=false;
BlockCutObj_Name="Grooves";

// 全部區塊中央底板 增加物件 
// Add objects to the center base of all blocks
Do_All_Block_Center_Put=false;
Do_All_Block_Center_Put_No_LastRow=false;
Do_All_Block_Center_Put_No_LastCol=false;
BlockPutObj_Name="Choc_LongBase";

/*
====================================
  文字顯示
  於預覽狀態(F5)標記出座標數值，以便於設定
  Text Display
  Mark the coordinate values in preview mode (F5) for easy configuration.

  例如Tray_Separator_Cut_L可指定：
  For example, Tray_Separator_Cut_L can be specified as:
  
     Tray_Separator_Cut_L=[
     [1,1],[2,1],[3,1],[1,2]
     ];  
====================================
*/

// 0關閉，其他數字為字體大小
// 0 to close, any other number is the font size
ShowText = 2 ;

//清除項目:
// Clear items:

// 長(水平)分隔片 紅色
// Long (horizontal) separator piece, red
Tray_Separator_Cut_L=[
];
// 寬(垂直)分隔片 藍色,     
// Wide (vertical) separator piece, blue
Tray_Separator_Cut_W=[
];
// 交錯點 綠色 長寬分隔片交會處
// Cross point, green, where the long and wide separator pieces intersect
// 須手動清除交錯點
// Manual clearing is required for the cross point
Tray_Separator_Cut_C=[
];
// 長(水平)底板 紅色
// Long (horizontal) base piece, red
Tray_Separator_Cut_LB=[
];
// 寬(垂直)底板 藍色
// Wide (vertical) base piece, blue
Tray_Separator_Cut_WB=[
];
// 長(水平)底板 僅上方 紅色
// Long (horizontal) base piece, top side only, red
Tray_Separator_Cut_LBU=[
];
// 長(水平)底板 僅下方 紅色
// Long (horizontal) base piece, bottom side only, red
Tray_Separator_Cut_LBD=[
];
// 區塊中央底板 移除物件 紫色 
// Block center base, remove objects, purple
Block_Cut_CT=[
];

//增加項目:
// Add items:

// 長(水平)分隔片 紅色
// Long (horizontal) separator piece, red
Tray_Separator_Put_L=[
];
// 寬(垂直)分隔片 藍色     
// Wide (vertical) separator piece, blue
Tray_Separator_Put_W=[
];
// 交錯點 綠色 長寬分隔片交會處
// Cross point, green, where the long and wide separator pieces intersect
Tray_Separator_Put_C=[
];
// 長(水平)底板 紅色
// Long (horizontal) base piece, red
Tray_Separator_Put_LB=[
];
// 寬(垂直)底板 藍色
// Wide (vertical) base piece, blue
Tray_Separator_Put_WB=[
];
// 區塊中央底板 增加物件 紫色 
// Block center base, add objects, purple
Block_Put_CT=[
];

/*
====================================
  F5預覽模擬
  可檢視紙盒與托盤的存放關係
  F5 Preview Simulation
  View the storage relationship between the box and the tray
====================================
*/
ShowOuterrBox=false; //是否顯示外盒？Show Outer Box?
ShowFillingUpTrays=false; //模擬塞滿托盤？Simulate filling up multiple trays?

//==================
//  建立鍵帽存放托盤
//==================
// Create Keycap Storage Tray
CreateKST();


//===上蓋===


//==================
//建立鍵帽存放托盤上蓋
//==================
// Create Keycap Storage Tray Cover
// 上蓋高度
// Cover height
Cover_H=4.9;
//CreateKST_Cover();
