/*
====================================
  鍵帽存放托盤產生器(KSTG)
  Keycap Storage Tray Generator
====================================
使用 include <KSTG_Base.SCAD> 加載此檔案
Use include <KSTG_Base.SCAD> to load this file

建立鍵帽存放托盤
Create Keycap Storage Tray
CreateKST();

建立鍵帽存放托盤上蓋
Create Keycap Storage Tray Cover
CreateKST_Cover();

KSTG_Template.scad 有詳細設定說明
KSTG_Template.scad contains detailed configuration instructions
*/

module CreateBase() 
{
//邊緣分隔板厚度(分隔片厚度 與 外圍厚度 取最小值)
Edge_Separator_L_T = Tray_Fence_T > Tray_Separator_T_L ?  Tray_Separator_T_L : Tray_Fence_T ;
Edge_Separator_W_T= Tray_Fence_T > Tray_Separator_T_W ? Tray_Fence_T : Tray_Separator_T_W ;
    
//水平分隔片 行數 (長;水平)
//=((外盒寬度 - (外圍厚度*2) + 邊緣分隔板厚度L )
//  /(放置鍵帽空間W+分隔片L厚度))

Tray_HS_Q = floor((BoxSize_W1-(Tray_Fence_T*2)+Edge_Separator_L_T)/(Keycaps_Space_W+Tray_Separator_T_L));

//垂直分隔片 列數 (寬;垂直)
//=((外盒長度 - (外圍厚度*2) + 邊緣分隔板厚度W )
//  /(放置鍵帽空間L+分隔片W厚度))

Tray_VS_Q = floor((BoxSize_L1-(Tray_Fence_T*2)+Edge_Separator_W_T)/(Keycaps_Space_L+Tray_Separator_T_W));

//盒子可放幾個托盤
Tray_Q = floor(BoxSize_H1/(Tray_Column_H+Tray_Bottom_T));

echo(str("存放盒子長寬高：", BoxSize_L1," x ",BoxSize_W1," x ",BoxSize_H1, " mm"));

echo(str("托盤分隔 行x列 數：", Tray_HS_Q,"行 x ",Tray_VS_Q,"列"));

//可使用總U數
echo(str("單一托盤可裝：", Tray_HS_Q*Tray_VS_Q, "U"));
echo(str("單盒可存盤數：", Tray_Q, "盤"));
echo(str("單盒可存鍵帽：", Tray_HS_Q*Tray_VS_Q*Tray_Q, "U"));

// 修正後存放盒子的大小:
BoxSize_L2 = Tray_VS_Q*(Keycaps_Space_L+Tray_Separator_T_W)+(Tray_Fence_T*2)-Tray_Separator_T_W; //長度
BoxSize_W2 = Tray_HS_Q*(Keycaps_Space_W+Tray_Separator_T_L)+(Tray_Fence_T*2)-Tray_Separator_T_L; //寬度
BoxSize_H2 = Tray_Q * (Tray_Column_H+Tray_Bottom_T); //高度

echo(str("使用空間L2=", BoxSize_L2, " mm"));
echo(str("使用空間W2=", BoxSize_W2, " mm"));
echo(str("使用空間H2=", BoxSize_H2, " mm"));

//多出來的邊界空間
ES_L2=BoxSize_L1-BoxSize_L2;
ES_W2=BoxSize_W1-BoxSize_W2;
ES_H2=BoxSize_H1-BoxSize_H2;

ES_L=ES_L2/2;
ES_W=ES_W2/2;

echo(str("多餘空間L(雙邊總和)=", ES_L2, " mm"));
echo(str("多餘空間W(雙邊總和)=", ES_W2, " mm"));
echo(str("多餘空間H(頂層)=", ES_H2, " mm"));
echo(str("1U存放空間：",Keycaps_Space_L," x ",Keycaps_Space_W," x ", Tray_Column_H," mm"));


echo(str("中央開口：",Keycaps_Space_W-(Tray_Bottom_W*2)," x ",Keycaps_Space_L-(Tray_Bottom_L*2)," x ",Tray_Bottom_T," mm"));

BoxSize_L = ExtraSpaceUse==0 ? BoxSize_L1 : BoxSize_L2;
BoxSize_W = ExtraSpaceUse==0 ? BoxSize_W1 : BoxSize_W2;

Tray_Corner_FST_H =
        (Tray_Corner_FST) && (Tray_Column_H>=Tray_Fence_H) && (Tray_Column_H>=ES_H) 
        ?  Tray_Column_H + Tray_Bottom_T + Tray_Corner_FST_HA
        : (Tray_Corner_FST) && (Tray_Fence_H>=Tray_Column_H) && (Tray_Fence_H>=ES_H) 
        ?  Tray_Fence_H + Tray_Bottom_T + Tray_Corner_FST_HA
        : (Tray_Corner_FST) && (ES_H>=Tray_Column_H) && (ES_H>=Tray_Fence_H) 
        ?  ES_H + Tray_Bottom_T + Tray_Corner_FST_HA 
        : 0;
        
echo(str("卡榫高度=", Tray_Corner_FST_H, " mm"));

Tray_Fence_T2 = (Tray_Corner_FST && Tray_Corner_FST_Type == 2) ? Tray_Fence_T:0;

//分隔板最高的高度
Tray_Separator_H1 =
        Tray_Separator_H_L>=Tray_Separator_H_W
        ?  Tray_Separator_H_L : Tray_Separator_H_W;

//F5預覽檢視 模擬
//顯示存放盒
if (ShowOuterrBox==true) {
    translate([-ES_L,-ES_W,0])
    %cube([BoxSize_L1,BoxSize_W1,BoxSize_H1]);
}   
//模擬塞滿托盤
if (ShowFillingUpTrays==true) {
    for (iTQ =[0 : Tray_Q-1]) {
        FirstTop_Tray= (iTQ==Tray_Q-1) ? true: false;
        translate([0,0,iTQ*Tray_Corner_FST_H])
        Tary(FirstTop_Tray);
    }
} else {
    Tary();
}        

module Tary(FirstTop_Tray=false)
{

FST_NoTenon =  (FirstTop_Tray==true) ? true : Tray_Corner_FST_NoTenon;

echo(str("省略頂端=", FST_NoTenon, ""));

difference()
{
    union()
    {

        //繪製四面牆
        cube([BoxSize_L,Tray_Fence_T,Tray_Fence_H+Tray_Bottom_T],false); //長 水平
        cube([Tray_Fence_T,BoxSize_W,Tray_Fence_H+Tray_Bottom_T],false); //寬 垂直
        translate([0,BoxSize_W-Tray_Fence_T,0]) 
            cube([BoxSize_L,Tray_Fence_T,Tray_Fence_H+Tray_Bottom_T],false);
        translate([BoxSize_L-Tray_Fence_T,0,0]) 
            cube([Tray_Fence_T,BoxSize_W,Tray_Fence_H+Tray_Bottom_T],false);
            
        //長 水平 底板    
        //translate([0,Tray_Fence_T,0]) 
        //    cube([BoxSize_L,Tray_Bottom_L+Tray_Separator_T/2,Tray_Bottom_T],false);
        //translate([0,BoxSize_W-Tray_Fence_T-Tray_Bottom_L,0]) 
        //    cube([BoxSize_L,Tray_Bottom_L,Tray_Bottom_T],false);
            
        //牆旁底板(寬;垂直)
        //左側
        translate([0,0,0]) 
            cube([Tray_Fence_T+Tray_Bottom_W,BoxSize_W,Tray_Bottom_T],false);
        //右側
        translate([BoxSize_L-(Tray_Fence_T+Tray_Bottom_W),0,0]) 
            cube([Tray_Fence_T+Tray_Bottom_W,BoxSize_W,Tray_Bottom_T],false);

        //水平搭橋 四面牆不處理   

        //底板

        //水平
        for (i =[1:Tray_HS_Q])
        translate([0,(Keycaps_Space_W+Tray_Separator_T_L)*i-Tray_Bottom_L+Tray_Fence_T-Tray_Separator_T_L,0]) 
            cube([BoxSize_L,Tray_Bottom_L,Tray_Bottom_T],false);

        for (i =[1:Tray_HS_Q])
        translate([0,(Keycaps_Space_W+Tray_Separator_T_L)*(i-1)+Tray_Fence_T,0]) 
            cube([BoxSize_L,Tray_Bottom_L,Tray_Bottom_T],false);

        //水平分隔片 
        //abs(Tray_Fence_T-Tray_Separator_T)
        for (i =[1:Tray_HS_Q-1])
        translate([0,(Keycaps_Space_W+Tray_Separator_T_L)*i+Tray_Fence_T-Tray_Separator_T_L,0]) 
            cube([BoxSize_L,Tray_Separator_T_L,Tray_Separator_H_L+Tray_Bottom_T],false);
            
        //垂直搭橋

        // 0 不使用
        //if(Tray_VS_Type==0);

        // 1、3 底板
        if(Tray_VS_Type==1 || Tray_VS_Type==3 || Tray_VS_Type==4) {
            //右
            for (i =[1:Tray_VS_Q])
            translate([(Keycaps_Space_L+Tray_Separator_T_W)*i-Tray_Bottom_W-Tray_Separator_T_W+Tray_Fence_T,0,0]) 
                cube([Tray_Bottom_W,BoxSize_W,Tray_Bottom_T],false);
            //左
            for (i =[0:Tray_VS_Q-1])
            translate([(Keycaps_Space_L+Tray_Separator_T_W)*i+Tray_Fence_T,0,0]) 
                cube([Tray_Bottom_W,BoxSize_W,Tray_Bottom_T],false);
            //中
            for (i =[1:Tray_VS_Q-1])
            translate([(Keycaps_Space_L+Tray_Separator_T_W)*i-Tray_Separator_T_W+Tray_Fence_T,0,0])  
                cube([Tray_Separator_T_W,BoxSize_W,Tray_Bottom_T],false);
            }

        // 垂直分隔片  
        // 2、3 短隔板
        if(Tray_VS_Type==2 || Tray_VS_Type==3) {
              
            //上
            for (i =[1:Tray_VS_Q-1])
                for (j =[1:Tray_HS_Q])
            translate([(Keycaps_Space_L+Tray_Separator_T_W)*i+Tray_Fence_T-Tray_Separator_T_W,(Keycaps_Space_W+Tray_Separator_T_L)*j-Tray_Separator_L+Tray_Fence_T-Tray_Separator_T_L,0]) 
                cube([Tray_Separator_T_W,Tray_Separator_L,Tray_Separator_H_W+Tray_Bottom_T],false);
            //下
            for (i =[1:Tray_VS_Q-1])
                for (j =[1:Tray_HS_Q])
            translate([(Keycaps_Space_L+Tray_Separator_T_W)*i+Tray_Fence_T-Tray_Separator_T_W,(Keycaps_Space_W+Tray_Separator_T_L)*(j-1)+Tray_Fence_T,0]) 
                cube([Tray_Separator_T_W,Tray_Separator_L,Tray_Separator_H_W+Tray_Bottom_T],false);

            }
        // 2 全部
        else if(Tray_VS_Type==1) {
            //垂直分隔片    
            for (i =[1:Tray_VS_Q-1])
            translate([(Keycaps_Space_L+Tray_Separator_T_W)*i+Tray_Fence_T-Tray_Separator_T_W,0,0]) 
                cube([Tray_Separator_T_W,BoxSize_W,Tray_Separator_H_W+Tray_Bottom_T],false);
            
            }
         
        //多餘空間處理方式
        // 2 角落填補剩餘空間
         if (ExtraSpaceUse == 2) {
            //左下下
            translate([Tray_Fence_T2,-ES_W,0]) 
                cube([ES_WE,ES_W,ES_H],false);
            //左下左
             translate([-ES_L,Tray_Fence_T2,0]) 
                cube([ES_L,ES_LE,ES_H],false);    
             //左上左
             translate([-ES_L,BoxSize_W-ES_LE-Tray_Fence_T2,0]) 
                cube([ES_L,ES_LE,ES_H],false); 
             //左上上
             translate([Tray_Fence_T2,BoxSize_W,0]) 
                cube([ES_WE,ES_W,ES_H],false);
             //右下右
             translate([BoxSize_L,Tray_Fence_T2,0]) 
                cube([ES_L,ES_LE,ES_H],false);    
             //右下下
             translate([BoxSize_L-ES_WE-Tray_Fence_T2,-ES_W,0]) 
                cube([ES_WE,ES_W,ES_H],false);
             //右上右
             translate([BoxSize_L,BoxSize_W-ES_LE-Tray_Fence_T2,0]) 
                cube([ES_L,ES_LE,ES_H],false);    
             //右上上
             translate([BoxSize_L-ES_WE-Tray_Fence_T2,BoxSize_W,0]) 
                cube([ES_WE,ES_W,ES_H],false);
                
            }

         //Tray Fixed Slot Tenon (in Corner )
         //托盤固定槽榫（位於角落）


         //1 外圍外側
         if (Tray_Corner_FST && Tray_Corner_FST_Type == 1) {        
            //左下
            translate([0,0,0]) 
                Corner_FST(Tray_Corner_FST_H,FST_NoTenon);
             //左上
             translate([0,BoxSize_W,0]) 
                rotate([0,0,-90])
                Corner_FST(Tray_Corner_FST_H,FST_NoTenon);
             //右下
             translate([BoxSize_L,0,0]) 
                rotate([0,0,90])
                Corner_FST(Tray_Corner_FST_H,FST_NoTenon);
             //右上
             translate([BoxSize_L,BoxSize_W,0]) 
                rotate([0,0,-180])
                Corner_FST(Tray_Corner_FST_H,FST_NoTenon);

            } 

             
        // 四角落立柱
          
        Tray_Column_T_L = Tray_Column_T > Tray_Fence_T + ES_L ?  Tray_Fence_T + ES_L : Tray_Column_T ;

        Tray_Column_T_W = Tray_Column_T > Tray_Fence_T + ES_W ?  Tray_Fence_T + ES_W : Tray_Column_T ;

        Tray_Column_T_L2 = (Tray_Corner_FST) ? 0:Tray_Column_T_L - Tray_Fence_T;
        Tray_Column_T_W2 = (Tray_Corner_FST) ? 0:Tray_Column_T_W - Tray_Fence_T;
                
        // 左下下
        translate([Tray_Fence_T2,Tray_Fence_T-Tray_Column_T_W,0]) 
            cube([Tray_Column_L-Tray_Fence_T2,Tray_Column_T_W,Tray_Column_H+Tray_Bottom_T],false);  
        // 左下左
        translate([Tray_Fence_T-Tray_Column_T_L,-Tray_Column_T_W2+Tray_Fence_T2,0]) 
            cube([Tray_Column_T_L,Tray_Column_W+Tray_Column_T_W2-Tray_Fence_T2,Tray_Column_H+Tray_Bottom_T],false);   
        // 右下下
        translate([BoxSize_L-Tray_Column_L,Tray_Fence_T-Tray_Column_T_W,0]) 
            cube([Tray_Column_L-Tray_Fence_T2,Tray_Column_T_W,Tray_Column_H+Tray_Bottom_T],false);
        // 右下右
        translate([BoxSize_L-Tray_Column_T_L-Tray_Fence_T+Tray_Column_T_L,-Tray_Column_T_W2+Tray_Fence_T2,0]) 
            cube([Tray_Column_T_L,Tray_Column_W+Tray_Column_T_W2-Tray_Fence_T2,Tray_Column_H+Tray_Bottom_T],false); 
        // 左上上     
        translate([Tray_Fence_T2,BoxSize_W-Tray_Column_T_W-Tray_Fence_T+Tray_Column_T_W,0]) 
            cube([Tray_Column_L-Tray_Fence_T2,Tray_Column_T_W,Tray_Column_H+Tray_Bottom_T],false);
        // 左上左   
        translate([Tray_Fence_T-Tray_Column_T_L,BoxSize_W-Tray_Column_W,0])
            cube([Tray_Column_T_L,Tray_Column_W+Tray_Column_T_W2-Tray_Fence_T2,Tray_Column_H+Tray_Bottom_T],false); 
        //右上上
        translate([BoxSize_L-Tray_Column_L,BoxSize_W-Tray_Column_T_W-Tray_Fence_T+Tray_Column_T_W,0]) 
            cube([Tray_Column_L-Tray_Fence_T2,Tray_Column_T_W,Tray_Column_H+Tray_Bottom_T],false);
        //右上右   
        translate([BoxSize_L-Tray_Column_T_L-Tray_Fence_T+Tray_Column_T_L,BoxSize_W-Tray_Column_W,0])
            cube([Tray_Column_T_L,Tray_Column_W+Tray_Column_T_W2-Tray_Fence_T2,Tray_Column_H+Tray_Bottom_T],false); 


        if (Do_All_Block_Center_Put) {Put_All_CT(Tray_VS_Q,Tray_HS_Q);}
    }
  
if (Do_All_Block_Center_Cut) {Cut_All_CT(Tray_VS_Q,Tray_HS_Q);}

//四角落 托盤固定槽榫: 2 外圍內側 (挖開空間)
if (Tray_Corner_FST && Tray_Corner_FST_Type == 2) {        
        //左下
    translate([Tray_Fence_T,Tray_Fence_T,-0.001]) 
        Corner_FST_SP(Tray_Corner_FST_H);
         //左上
    translate([Tray_Fence_T,BoxSize_W-Tray_Fence_T,-0.001]) 
        rotate([0,0,-90])
        Corner_FST_SP(Tray_Corner_FST_H);
         //右下
    translate([BoxSize_L-Tray_Fence_T,Tray_Fence_T,-0.001]) 
        rotate([0,0,90])
        Corner_FST_SP(Tray_Corner_FST_H);
         //右上
    translate([BoxSize_L-Tray_Fence_T,BoxSize_W-Tray_Fence_T,-0.001]) 
        rotate([0,0,-180])
        Corner_FST_SP(Tray_Corner_FST_H);
            
            //3 盒子邊緣
            //ExtraSpaceUse = 0 排除
} else if (Tray_Corner_FST && Tray_Corner_FST_Type == 3 &&  ExtraSpaceUse!=0 ) {

            //左下
            translate([-ES_L+Tray_Corner_FST_L,-ES_W+Tray_Corner_FST_W,0]) 
                Corner_FST_SP(Tray_Corner_FST_H);
                
             //左上
             translate([-ES_L+Tray_Corner_FST_W,BoxSize_W+ES_W-Tray_Corner_FST_L,0]) 
                rotate([0,0,-90])
                Corner_FST_SP(Tray_Corner_FST_H);
                
             //右下
             translate([BoxSize_L+ES_L-Tray_Corner_FST_W,-ES_W+Tray_Corner_FST_L,0]) 
                rotate([0,0,90])
                Corner_FST_SP(Tray_Corner_FST_H);
                
             //右上
             translate([BoxSize_L+ES_L-Tray_Corner_FST_L,BoxSize_W+ES_W-Tray_Corner_FST_W,0]) 
                rotate([0,0,-180])
                Corner_FST_SP(Tray_Corner_FST_H);

    }      

}

//四角落 托盤固定槽榫: 2 外圍內側 (加入物件)
if (Tray_Corner_FST && Tray_Corner_FST_Type == 2) {        
        //左下
    translate([Tray_Fence_T,Tray_Fence_T,0]) 
        Corner_FST(Tray_Corner_FST_H,FST_NoTenon);
         //左上
    translate([Tray_Fence_T,BoxSize_W-Tray_Fence_T,0]) 
        rotate([0,0,-90])
        Corner_FST(Tray_Corner_FST_H,FST_NoTenon);
         //右下
    translate([BoxSize_L-Tray_Fence_T,Tray_Fence_T,0]) 
        rotate([0,0,90])
        Corner_FST(Tray_Corner_FST_H,FST_NoTenon);
         //右上
    translate([BoxSize_L-Tray_Fence_T,BoxSize_W-Tray_Fence_T,0]) 
        rotate([0,0,-180])
        Corner_FST(Tray_Corner_FST_H,FST_NoTenon);

        
            //3 盒子邊緣
            //ExtraSpaceUse = 0 排除
} else if (Tray_Corner_FST && Tray_Corner_FST_Type == 3 &&  ExtraSpaceUse!=0 ) {

            //左下
            translate([-ES_L+Tray_Corner_FST_L,-ES_W+Tray_Corner_FST_W,0]) 
                Corner_FST(Tray_Corner_FST_H,FST_NoTenon);
                translate([-(ES_L-Tray_Corner_FST_L),-ES_W,0])
                cube([ES_L-Tray_Corner_FST_L,ES_W,Tray_Corner_FST_H]);
                
                translate([-ES_L,-(ES_W-Tray_Corner_FST_W),0])
                cube([ES_L,ES_W-Tray_Corner_FST_W,Tray_Corner_FST_H]);
                
             //左上
             translate([-ES_L+Tray_Corner_FST_W,BoxSize_W+ES_W-Tray_Corner_FST_L,0]) 
                rotate([0,0,-90])
                Corner_FST(Tray_Corner_FST_H,FST_NoTenon);
                translate([-(ES_L-Tray_Corner_FST_W),BoxSize_W,0])
                cube([ES_L-Tray_Corner_FST_W,ES_W,Tray_Corner_FST_H]);
                translate([-ES_L,BoxSize_W,0])
                cube([ES_L,ES_W-Tray_Corner_FST_L,Tray_Corner_FST_H]);
                                
             //右下
             translate([BoxSize_L+ES_L-Tray_Corner_FST_W,-ES_W+Tray_Corner_FST_L,0]) 
                rotate([0,0,90])
                Corner_FST(Tray_Corner_FST_H,FST_NoTenon);
                translate([BoxSize_L,-ES_W,0])
                cube([ES_L-Tray_Corner_FST_W,ES_W,Tray_Corner_FST_H]);
                translate([BoxSize_L,-(ES_W-Tray_Corner_FST_L),0])
                cube([ES_L,ES_W-Tray_Corner_FST_L,Tray_Corner_FST_H]);
                
             //右上
             translate([BoxSize_L+ES_L-Tray_Corner_FST_L,BoxSize_W+ES_W-Tray_Corner_FST_W,0]) 
                rotate([0,0,-180])
                Corner_FST(Tray_Corner_FST_H,FST_NoTenon);
                translate([BoxSize_L,BoxSize_W,0])
                cube([ES_L-Tray_Corner_FST_L,ES_W,Tray_Corner_FST_H]);
                translate([BoxSize_L,BoxSize_W,0])
                cube([ES_L,ES_W-Tray_Corner_FST_W,Tray_Corner_FST_H]);
                
    }     
    
//文字標記
if (ShowText!=0 && $preview==true) { 

for (i =[1:Tray_VS_Q])
    for (j =[1:Tray_HS_Q-1])
    translate([(
    Keycaps_Space_L+Tray_Separator_T_W)*i+Tray_Fence_T-Tray_Separator_T_W-Keycaps_Space_L/1.5,
    (Keycaps_Space_W+Tray_Separator_T_L)*j-(Tray_Bottom_W+Tray_Separator_T_L)/2+Tray_Fence_T,
    Tray_Bottom_T+Tray_Separator_H_L+1]) 
        color( "Red", 0.3 )text(str(i,",",j),ShowText);

for (i =[1:Tray_VS_Q])
    for (j =[1:Tray_HS_Q])
    translate([(
    Keycaps_Space_L+Tray_Separator_T_W)*i+Tray_Fence_T-Tray_Separator_T_W-Keycaps_Space_L/1.5,
    (Keycaps_Space_W+Tray_Separator_T_L)*(j-1)+(Keycaps_Space_W/2),
    Tray_Bottom_T+Tray_Separator_H1+1]) 
        color( "Purple", 0.3 )text(str(i,",",j),ShowText);
        
for (i =[1:Tray_VS_Q-1])
    for (j =[1:Tray_HS_Q])
    //-Tray_Bottom_L+Tray_Fence_T-Tray_Separator_T_L-Keycaps_Space_W/2+3
    translate([
    (Keycaps_Space_L+Tray_Separator_T_W)*i+Tray_Fence_T-Tray_Separator_T_W-Keycaps_Space_L/4+2,
    (Keycaps_Space_W+Tray_Separator_T_L)*j-(Tray_Bottom_W+Tray_Separator_T_L)/2+Tray_Fence_T-Keycaps_Space_W/2-1.5,
    Tray_Bottom_T+Tray_Separator_H_W+1]) 
        color( "Blue", 0.3 )text(str(i,",",j),ShowText);

for (i =[1:Tray_VS_Q-1])
    for (j =[1:Tray_HS_Q-1])
    translate([(
    Keycaps_Space_L+Tray_Separator_T_W)*i+Tray_Fence_T-Tray_Separator_T_W-Keycaps_Space_L/4+3,
    (Keycaps_Space_W+Tray_Separator_T_L)*j-(Tray_Bottom_W+Tray_Separator_T_L)/2+Tray_Fence_T,
    Tray_Bottom_T+Tray_Separator_H1+1]) 
        color( "Lime", 0.3 )text(str(i,",",j),ShowText);
    
};

}

}

module CreateCover() 
{
//邊緣分隔板厚度(分隔片厚度 與 外圍厚度 取最小值)
Edge_Separator_L_T = Tray_Fence_T > Tray_Separator_T_L ?  Tray_Separator_T_L : Tray_Fence_T ;
Edge_Separator_W_T= Tray_Fence_T > Tray_Separator_T_W ? Tray_Fence_T : Tray_Separator_T_W ;
    
//水平分隔片 行數 (長;水平)
//=((外盒寬度 - (外圍厚度*2) + 邊緣分隔板厚度L )
//  /(放置鍵帽空間W+分隔片L厚度))

Tray_HS_Q = floor((BoxSize_W1-(Tray_Fence_T*2)+Edge_Separator_L_T)/(Keycaps_Space_W+Tray_Separator_T_L));

//垂直分隔片 列數 (寬;垂直)
//=((外盒長度 - (外圍厚度*2) + 邊緣分隔板厚度W )
//  /(放置鍵帽空間L+分隔片W厚度))

Tray_VS_Q = floor((BoxSize_L1-(Tray_Fence_T*2)+Edge_Separator_W_T)/(Keycaps_Space_L+Tray_Separator_T_W));

//盒子可放幾個托盤
Tray_Q = floor(BoxSize_H1/(Tray_Column_H+Tray_Bottom_T));

// 修正後存放盒子的大小:
BoxSize_L2 = Tray_VS_Q*(Keycaps_Space_L+Tray_Separator_T_W)+(Tray_Fence_T*2)-Tray_Separator_T_W; //長度
BoxSize_W2 = Tray_HS_Q*(Keycaps_Space_W+Tray_Separator_T_L)+(Tray_Fence_T*2)-Tray_Separator_T_L; //寬度
BoxSize_H2 = Tray_Q * (Tray_Column_H+Tray_Bottom_T); //高度

echo(str("使用空間L2=", BoxSize_L2, " mm"));
echo(str("使用空間W2=", BoxSize_W2, " mm"));
echo(str("使用空間H2=", BoxSize_H2, " mm"));

//多出來的邊界空間
ES_L2=BoxSize_L1-BoxSize_L2;
ES_W2=BoxSize_W1-BoxSize_W2;
ES_H2=BoxSize_H1-BoxSize_H2;

ES_L=ES_L2/2;
ES_W=ES_W2/2;

BoxSize_L = ExtraSpaceUse==0 ? BoxSize_L1 : BoxSize_L2;
BoxSize_W = ExtraSpaceUse==0 ? BoxSize_W1 : BoxSize_W2;

Tray_Corner_FST_H =
        (Tray_Corner_FST) && (Tray_Column_H>=Tray_Fence_H) && (Tray_Column_H>=ES_H) 
        ?  Tray_Column_H + Tray_Bottom_T + Tray_Corner_FST_HA
        : (Tray_Corner_FST) && (Tray_Fence_H>=Tray_Column_H) && (Tray_Fence_H>=ES_H) 
        ?  Tray_Fence_H + Tray_Bottom_T + Tray_Corner_FST_HA
        : (Tray_Corner_FST) && (ES_H>=Tray_Column_H) && (ES_H>=Tray_Fence_H) 
        ?  ES_H + Tray_Bottom_T + Tray_Corner_FST_HA 
        : 0;
        
echo(str("卡榫高度=", Tray_Corner_FST_H, " mm"));

Tray_Fence_T2 = (Tray_Corner_FST && Tray_Corner_FST_Type == 2) ? Tray_Fence_T:0;


difference()
{
    union()
    {

        //繪製四面牆
        difference(){
        cube([BoxSize_L,BoxSize_W,Tray_Fence_H+Tray_Bottom_T],false); 
        translate([Tray_Fence_T,Tray_Fence_T,Tray_Bottom_T])
        cube([BoxSize_L-Tray_Fence_T*2,BoxSize_W-Tray_Fence_T*2,Tray_Fence_H],false); 
        
        }
        //長 水平 底板    
        //translate([0,Tray_Fence_T,0]) 
        //    cube([BoxSize_L,Tray_Bottom_L+Tray_Separator_T/2,Tray_Bottom_T],false);
        //translate([0,BoxSize_W-Tray_Fence_T-Tray_Bottom_L,0]) 
        //    cube([BoxSize_L,Tray_Bottom_L,Tray_Bottom_T],false);
            
        //牆旁底板(寬;垂直)
        //左側
        translate([0,0,0]) 
            cube([Tray_Fence_T+Tray_Bottom_W,BoxSize_W,Tray_Bottom_T],false);
        //右側
        translate([BoxSize_L-(Tray_Fence_T+Tray_Bottom_W),0,0]) 
            cube([Tray_Fence_T+Tray_Bottom_W,BoxSize_W,Tray_Bottom_T],false);


         
        //多餘空間處理方式
        // 2 角落填補剩餘空間
         if (ExtraSpaceUse == 2) {
            //左下下
            translate([Tray_Fence_T2,-ES_W,0]) 
                cube([ES_WE,ES_W,ES_H],false);
            //左下左
             translate([-ES_L,Tray_Fence_T2,0]) 
                cube([ES_L,ES_LE,ES_H],false);    
             //左上左
             translate([-ES_L,BoxSize_W-ES_LE-Tray_Fence_T2,0]) 
                cube([ES_L,ES_LE,ES_H],false); 
             //左上上
             translate([Tray_Fence_T2,BoxSize_W,0]) 
                cube([ES_WE,ES_W,ES_H],false);
             //右下右
             translate([BoxSize_L,Tray_Fence_T2,0]) 
                cube([ES_L,ES_LE,ES_H],false);    
             //右下下
             translate([BoxSize_L-ES_WE-Tray_Fence_T2,-ES_W,0]) 
                cube([ES_WE,ES_W,ES_H],false);
             //右上右
             translate([BoxSize_L,BoxSize_W-ES_LE-Tray_Fence_T2,0]) 
                cube([ES_L,ES_LE,ES_H],false);    
             //右上上
             translate([BoxSize_L-ES_WE-Tray_Fence_T2,BoxSize_W,0]) 
                cube([ES_WE,ES_W,ES_H],false);
                
            }

         //Tray Fixed Slot Tenon (in Corner )
         //托盤固定槽榫（位於角落）


         //1 外圍外側
         if (Tray_Corner_FST && Tray_Corner_FST_Type == 1) {        
            //左下
            translate([0,0,0]) 
                Corner_FST(Tray_Corner_FST_H,true);
             //左上
             translate([0,BoxSize_W,0]) 
                rotate([0,0,-90])
                Corner_FST(Tray_Corner_FST_H,true);
             //右下
             translate([BoxSize_L,0,0]) 
                rotate([0,0,90])
                Corner_FST(Tray_Corner_FST_H,true);
             //右上
             translate([BoxSize_L,BoxSize_W,0]) 
                rotate([0,0,-180])
                Corner_FST(Tray_Corner_FST_H,true);

            //3 盒子邊緣
            //ExtraSpaceUse = 0 排除
            } else if (Tray_Corner_FST && Tray_Corner_FST_Type == 3 &&  ExtraSpaceUse!=0 ) {

            //左下
            translate([-ES_L+Tray_Corner_FST_L,-ES_W+Tray_Corner_FST_W,0]) 
                Corner_FST(Tray_Corner_FST_H,true);
                translate([-(ES_L-Tray_Corner_FST_L),-ES_W,0])
                cube([ES_L-Tray_Corner_FST_L,ES_W,Tray_Corner_FST_H]);
                
                translate([-ES_L,-(ES_W-Tray_Corner_FST_W),0])
                cube([ES_L,ES_W-Tray_Corner_FST_W,Tray_Corner_FST_H]);
                
             //左上
             translate([-ES_L+Tray_Corner_FST_W,BoxSize_W+ES_W-Tray_Corner_FST_L,0]) 
                rotate([0,0,-90])
                Corner_FST(Tray_Corner_FST_H,true);
                translate([-(ES_L-Tray_Corner_FST_W),BoxSize_W,0])
                cube([ES_L-Tray_Corner_FST_W,ES_W,Tray_Corner_FST_H]);
                translate([-ES_L,BoxSize_W,0])
                cube([ES_L,ES_W-Tray_Corner_FST_L,Tray_Corner_FST_H]);
                                
             //右下
             translate([BoxSize_L+ES_L-Tray_Corner_FST_W,-ES_W+Tray_Corner_FST_L,0]) 
                rotate([0,0,90])
                Corner_FST(Tray_Corner_FST_H,true);
                translate([BoxSize_L,-ES_W,0])
                cube([ES_L-Tray_Corner_FST_W,ES_W,Tray_Corner_FST_H]);
                translate([BoxSize_L,-(ES_W-Tray_Corner_FST_L),0])
                cube([ES_L,ES_W-Tray_Corner_FST_L,Tray_Corner_FST_H]);
                
             //右上
             translate([BoxSize_L+ES_L-Tray_Corner_FST_L,BoxSize_W+ES_W-Tray_Corner_FST_W,0]) 
                rotate([0,0,-180])
                Corner_FST(Tray_Corner_FST_H,true);
                translate([BoxSize_L,BoxSize_W,0])
                cube([ES_L-Tray_Corner_FST_L,ES_W,Tray_Corner_FST_H]);
                translate([BoxSize_L,BoxSize_W,0])
                cube([ES_L,ES_W-Tray_Corner_FST_W,Tray_Corner_FST_H]);
                
    }

             
        // 四角落立柱
          
        Tray_Column_T_L = Tray_Column_T > Tray_Fence_T + ES_L ?  Tray_Fence_T + ES_L : Tray_Column_T ;

        Tray_Column_T_W = Tray_Column_T > Tray_Fence_T + ES_W ?  Tray_Fence_T + ES_W : Tray_Column_T ;

        Tray_Column_T_L2 = (Tray_Corner_FST) ? 0:Tray_Column_T_L - Tray_Fence_T;
        Tray_Column_T_W2 = (Tray_Corner_FST) ? 0:Tray_Column_T_W - Tray_Fence_T;
                
        // 左下下
        translate([Tray_Fence_T2,Tray_Fence_T-Tray_Column_T_W,0]) 
            cube([Tray_Column_L-Tray_Fence_T2,Tray_Column_T_W,Tray_Column_H+Tray_Bottom_T],false);  
        // 左下左
        translate([Tray_Fence_T-Tray_Column_T_L,-Tray_Column_T_W2+Tray_Fence_T2,0]) 
            cube([Tray_Column_T_L,Tray_Column_W+Tray_Column_T_W2-Tray_Fence_T2,Tray_Column_H+Tray_Bottom_T],false);   
        // 右下下
        translate([BoxSize_L-Tray_Column_L,Tray_Fence_T-Tray_Column_T_W,0]) 
            cube([Tray_Column_L-Tray_Fence_T2,Tray_Column_T_W,Tray_Column_H+Tray_Bottom_T],false);
        // 右下右
        translate([BoxSize_L-Tray_Column_T_L-Tray_Fence_T+Tray_Column_T_L,-Tray_Column_T_W2+Tray_Fence_T2,0]) 
            cube([Tray_Column_T_L,Tray_Column_W+Tray_Column_T_W2-Tray_Fence_T2,Tray_Column_H+Tray_Bottom_T],false); 
        // 左上上     
        translate([Tray_Fence_T2,BoxSize_W-Tray_Column_T_W-Tray_Fence_T+Tray_Column_T_W,0]) 
            cube([Tray_Column_L-Tray_Fence_T2,Tray_Column_T_W,Tray_Column_H+Tray_Bottom_T],false);
        // 左上左   
        translate([Tray_Fence_T-Tray_Column_T_L,BoxSize_W-Tray_Column_W,0])
            cube([Tray_Column_T_L,Tray_Column_W+Tray_Column_T_W2-Tray_Fence_T2,Tray_Column_H+Tray_Bottom_T],false); 
        //右上上
        translate([BoxSize_L-Tray_Column_L,BoxSize_W-Tray_Column_T_W-Tray_Fence_T+Tray_Column_T_W,0]) 
            cube([Tray_Column_L-Tray_Fence_T2,Tray_Column_T_W,Tray_Column_H+Tray_Bottom_T],false);
        //右上右   
        translate([BoxSize_L-Tray_Column_T_L-Tray_Fence_T+Tray_Column_T_L,BoxSize_W-Tray_Column_W,0])
            cube([Tray_Column_T_L,Tray_Column_W+Tray_Column_T_W2-Tray_Fence_T2,Tray_Column_H+Tray_Bottom_T],false); 
            
    }
  


//四角落 托盤固定槽榫: 2 外圍內側 (挖開空間)
if (Tray_Corner_FST && Tray_Corner_FST_Type == 2) {        
        //左下
    translate([Tray_Fence_T,Tray_Fence_T,-0.001]) 
        Corner_FST_SP(Tray_Corner_FST_H);
         //左上
    translate([Tray_Fence_T,BoxSize_W-Tray_Fence_T,-0.001]) 
        rotate([0,0,-90])
        Corner_FST_SP(Tray_Corner_FST_H);
         //右下
    translate([BoxSize_L-Tray_Fence_T,Tray_Fence_T,-0.001]) 
        rotate([0,0,90])
        Corner_FST_SP(Tray_Corner_FST_H);
         //右上
    translate([BoxSize_L-Tray_Fence_T,BoxSize_W-Tray_Fence_T,-0.001]) 
        rotate([0,0,-180])
        Corner_FST_SP(Tray_Corner_FST_H);

}
      
translate([-20,-20,Cover_H])
cube([BoxSize_L1+40,BoxSize_W1+40,BoxSize_H1]);


}

//四角落 托盤固定槽榫: 2 外圍內側 (加入物件)
if (Tray_Corner_FST && Tray_Corner_FST_Type == 2) {        

difference()
{
union()
{
        //左下
    translate([Tray_Fence_T,Tray_Fence_T,0]) 
        Corner_FST(Tray_Corner_FST_H,true);
         //左上
    translate([Tray_Fence_T,BoxSize_W-Tray_Fence_T,0]) 
        rotate([0,0,-90])
        Corner_FST(Tray_Corner_FST_H,true);
         //右下
    translate([BoxSize_L-Tray_Fence_T,Tray_Fence_T,0]) 
        rotate([0,0,90])
        Corner_FST(Tray_Corner_FST_H,true);
         //右上
    translate([BoxSize_L-Tray_Fence_T,BoxSize_W-Tray_Fence_T,0]) 
        rotate([0,0,-180])
        Corner_FST(Tray_Corner_FST_H,true);
}

translate([-20,-20,Cover_H])
cube([BoxSize_L1+40,BoxSize_W1+40,BoxSize_H1]);

}      
    
}
}

module Corner_FST(Tray_Corner_FST_H,FST_NoTenon)
{
    
    
    difference()
    {
    skew(zx = -Tray_Corner_FST_D, zy=-Tray_Corner_FST_D)
    linear_extrude(height = Tray_Corner_FST_H)
        polygon(points = [[0, 0], [-Tray_Corner_FST_L, 0], [0, -Tray_Corner_FST_W]]);

        translate([0,0,Tray_Corner_FST_H])
    linear_extrude(height = Tray_Corner_FST_H)
        polygon(points = [[0, 0], [-Tray_Corner_FST_L-0.01, 0], [0, -Tray_Corner_FST_W-0.01]]);
    }
    
    if (FST_NoTenon==false) {

    difference()
    {
        intersection()
        {
        skew(zx = -Tray_Corner_FST_D, zy=-Tray_Corner_FST_D)
        linear_extrude(height = Tray_Corner_FST_H-Tray_Corner_FST_S)
            polygon(points = [[-Tray_Corner_FST_S, -Tray_Corner_FST_S], [-Tray_Corner_FST_L, -Tray_Corner_FST_S], [-Tray_Corner_FST_S, -Tray_Corner_FST_W]]);

            translate([0,0,Tray_Corner_FST_H])
        linear_extrude(height = Tray_Corner_FST_H)
            polygon(points = [[0, 0], [-Tray_Corner_FST_L, 0], [0, -Tray_Corner_FST_W]]);
        }
//        #translate([0,0,Tray_Corner_FST_C])
        #translate([0,0,Tray_Corner_FST_TH+Tray_Corner_FST_H])
    linear_extrude(height = Tray_Corner_FST_H/2)
        polygon(points = [[0, 0], [-Tray_Corner_FST_L-0.01, 0], [0, -Tray_Corner_FST_W-0.01]]);
    }
   }
   } 

module Corner_FST_SP(Tray_Corner_FST_H)
{
    linear_extrude(height = Tray_Corner_FST_H+0.001)
        polygon(points = [[0, 0], [-Tray_Corner_FST_L, 0], [-Tray_Corner_FST_L, -Tray_Corner_FST_W], [0, -Tray_Corner_FST_W]]);

         
   } 
   
module Cut_All_CT(Tray_VS_Q,Tray_HS_Q){
    
    Tray_VS_D =   Do_All_Block_Center_Cut_No_LastCol ? 1 : 0 ;
    Tray_HS_D =   Do_All_Block_Center_Cut_No_LastRow ? 1 : 0 ;

    for (i =[1:(Tray_VS_Q-Tray_VS_D)])
        for (j =[1:(Tray_HS_Q-Tray_HS_D)])
            translate([
            (Keycaps_Space_L+Tray_Separator_T_W)*(i-1)+Tray_Fence_T+(Keycaps_Space_L/2),
            (Keycaps_Space_W+Tray_Separator_T_L)*(j)+Tray_Fence_T-Tray_Separator_T_L-Keycaps_Space_W/2,
            Tray_Bottom_T]) 
                BlockCutObj();
  }  

module Put_All_CT(Tray_VS_Q,Tray_HS_Q){

    Tray_VS_D =   Do_All_Block_Center_Put_No_LastCol ? 1 : 0 ;
    Tray_HS_D =   Do_All_Block_Center_Put_No_LastRow ? 1 : 0 ;

    for (i =[1:(Tray_VS_Q-Tray_VS_D)])
        for (j =[1:(Tray_HS_Q-Tray_HS_D)])
            translate([
            (Keycaps_Space_L+Tray_Separator_T_W)*( i-1)+Tray_Fence_T+(Keycaps_Space_L/2),
            (Keycaps_Space_W+Tray_Separator_T_L)*(j)+Tray_Fence_T-Tray_Separator_T_L-Keycaps_Space_W/2,
            Tray_Bottom_T]) 
                BlockPutObj();
  }  
  
module Cut_CT(items){
  for (item = items)
        translate([
        (Keycaps_Space_L+Tray_Separator_T_W)*(item[0]-1)+Tray_Fence_T+(Keycaps_Space_L/2),
        (Keycaps_Space_W+Tray_Separator_T_L)*(item[1])+Tray_Fence_T-Tray_Separator_T_L-Keycaps_Space_W/2,
        Tray_Bottom_T]) 
            BlockCutObj();
  }  

module Put_CT(items){
  for (item = items)
        translate([
        (Keycaps_Space_L+Tray_Separator_T_W)*(item[0]-1)+Tray_Fence_T+(Keycaps_Space_L/2),
        (Keycaps_Space_W+Tray_Separator_T_L)*(item[1])+Tray_Fence_T-Tray_Separator_T_L-Keycaps_Space_W/2,
        Tray_Bottom_T]) 
            BlockPutObj();
  }  
    
module Cut_L(items){
  for (item = items)
        translate([
        (Keycaps_Space_L+Tray_Separator_T_W)*(item[0]-1)+Tray_Fence_T,
        (Keycaps_Space_W+Tray_Separator_T_L)*(item[1])+Tray_Fence_T-Tray_Separator_T_L,
        Tray_Bottom_T]) 
            cube([Keycaps_Space_L,Tray_Separator_T_L,Tray_Separator_H_L]);
  }  
  
module Cut_W(items){
    for (item = items)
        translate([
        (Keycaps_Space_L+Tray_Separator_T_W)*item[0]+Tray_Fence_T-Tray_Separator_T_W,
        (Keycaps_Space_W+Tray_Separator_T_L)*(item[1]-1)+Tray_Fence_T,
        Tray_Bottom_T]) 
            cube([Tray_Separator_T_W,Keycaps_Space_W,Tray_Separator_H_W]);
    }    

module Cut_C(items){
    for (item = items)
        translate([
        (Keycaps_Space_L+Tray_Separator_T_W)*(item[0]-1)+Keycaps_Space_L+Tray_Fence_T,
        (Keycaps_Space_W+Tray_Separator_T_L)*(item[1])+Tray_Fence_T-Tray_Separator_T_L,
        Tray_Bottom_T]) 
            cube([Tray_Separator_T_W,Tray_Separator_T_L,Tray_Separator_H1]);
  }  

module Cut_LB(items){
  for (item = items)
        translate([
        (Keycaps_Space_L+Tray_Separator_T_W)*(item[0]-1)+Tray_Fence_T+Tray_Bottom_W,
        (Keycaps_Space_W+Tray_Separator_T_L)*(item[1])+Tray_Fence_T-Tray_Separator_T_L-Tray_Bottom_L,
        0]) 
        cube([Keycaps_Space_L-Tray_Bottom_W*2,Tray_Bottom_L*2+Tray_Separator_T_L,Tray_Bottom_T]);
  }  
  
//*2+Tray_Separator_T_L
module Cut_LBU(items){
  for (item = items)
        translate([
        (Keycaps_Space_L+Tray_Separator_T_W)*(item[0]-1)+Tray_Fence_T+Tray_Bottom_W,
        (Keycaps_Space_W+Tray_Separator_T_L)*(item[1])+Tray_Fence_T-Tray_Separator_T_L-Tray_Bottom_L+(Tray_Bottom_L+Tray_Separator_T_L),
        0]) 
        cube([Keycaps_Space_L-Tray_Bottom_W*2,Tray_Bottom_L,Tray_Bottom_T]);
  }  

module Cut_LBD(items){
  for (item = items)
        translate([
        (Keycaps_Space_L+Tray_Separator_T_W)*(item[0]-1)+Tray_Fence_T+Tray_Bottom_W,
        (Keycaps_Space_W+Tray_Separator_T_L)*(item[1])+Tray_Fence_T-Tray_Separator_T_L-Tray_Bottom_L,
        0]) 
        cube([Keycaps_Space_L-Tray_Bottom_W*2,Tray_Bottom_L,Tray_Bottom_T]);
  }  

  
module Cut_WB(items){
    for (item = items)
        translate([
        (Keycaps_Space_L+Tray_Separator_T_W)*(item[0])+Tray_Fence_T-Tray_Bottom_W-Tray_Separator_T_W,
        (Keycaps_Space_W+Tray_Separator_T_L)*(item[1]-1)+Tray_Fence_T+Tray_Bottom_L,
        0]) 
            cube([
            Tray_Bottom_W*2+Tray_Separator_T_W,
            Keycaps_Space_W-Tray_Bottom_L*2,
            Tray_Bottom_T]);
    }    

//外部程式:
//剪切效果
//https://gist.github.com/boredzo/fde487c724a40a26fa9c
// Skews the child geometry.
// xy: Angle towards X along Y axis.
// xz: Angle towards X along Z axis.
// yx: Angle towards Y along X axis.
// yz: Angle towards Y along Z axis.
// zx: Angle towards Z along X axis.
// zy: Angle towards Z along Y axis.
module skew(xy = 0, xz = 0, yx = 0, yz = 0, zx = 0, zy = 0) {
	matrix = [
		[ 1, tan(xy), tan(xz), 0 ],
		[ tan(yx), 1, tan(yz), 0 ],
		[ tan(zx), tan(zy), 1, 0 ],
		[ 0, 0, 0, 1 ]
	];
	multmatrix(matrix)
	children();
}

//--

//增減物件

module BlockCutObj()
{
if (BlockCutObj_Name=="Grooves")
{
BlockCutObj_Grooves();
}

}

module BlockPutObj()
{
if (BlockPutObj_Name=="Choc_Base")
{
    BlockPutObj_Choc_Base();
} else if (BlockPutObj_Name=="Choc_LongBase")
{
    BlockPutObj_Choc_LongBase();
}
}

//減物件-分隔片挖出凹槽
module BlockCutObj_Grooves()
{
    translate([0,Keycaps_Space_W/2,13])
    rotate([90,0,0])
    cylinder(h=1.5, d1=20, d2=20, center=true);
}

//增加物件-Choc V1用中央突起Stem座
//底部內凹，便於手指由底部推出鍵帽
module BlockPutObj_Choc_Base()
{
    translate([0,0,-Tray_Bottom_T])
    difference()
    {
    hull()
    {
    translate([0,0,(4)])
    cube([13-1,8-1,0.001],center=true);
    translate([0,0,0])
    cube([15+1,11+2.5,0.001],center=true);    
    }
    //cube([13-1,8-1,(4+Tray_Bottom_T)],center=true);
    hull()
    {
    translate([0,0,4+0.01])
    //Choc stem開口 長6.9x寬2.8
    //可依照需求增減尺寸
    //開口如果使用TPU，寬可縮減以便夾緊
    cube([6.9+0.3,2.8-0.3,0.1],center=true);
    translate([0,0,-0.1])
    cube([6.9+6+1,3+6+2.5,0.1],center=true);    
    }
    }
}

module BlockPutObj_Choc_LongBase()
{
    translate([0,0,-Tray_Bottom_T])
    difference()
    {
    hull()
    {
    translate([0,0,(4)])
    cube([Keycaps_Space_L+Tray_Separator_T_W,8-1,0.001],center=true);
    translate([0,0,0])
    cube([Keycaps_Space_L+Tray_Separator_T_W,11+2.5,0.001],center=true);    
    }
    //cube([13-1,8-1,(4+Tray_Bottom_T)],center=true);
    hull()
    {
    translate([0,0,4+0.01])
    //Choc stem開口 長6.9x寬2.8
    //可依照需求增減尺寸
    //開口如果使用TPU，寬可縮減以便夾緊
    cube([Keycaps_Space_L+Tray_Separator_T_W,2.8-0.4,0.1],center=true);
    translate([0,0,-0.1])
    cube([Keycaps_Space_L+Tray_Separator_T_W,3+6+2.5,0.1],center=true);    
    }
    }
}
  
//產生鍵帽存放托盤
module CreateKST()
{
difference() {
    //建立基礎
    CreateBase();
    //剪除項目
    Cut_L(Tray_Separator_Cut_L);
    Cut_W(Tray_Separator_Cut_W);
    Cut_C(Tray_Separator_Cut_C);
    Cut_LB(Tray_Separator_Cut_LB);
    Cut_WB(Tray_Separator_Cut_WB);
    Cut_LBU(Tray_Separator_Cut_LBU);
    Cut_LBD(Tray_Separator_Cut_LBD);
    Cut_CT(Block_Cut_CT);
    
    }
    
//增加項目
Cut_L(Tray_Separator_Put_L);
Cut_W(Tray_Separator_Put_W);
Cut_C(Tray_Separator_Put_C);
Cut_LB(Tray_Separator_Put_LB);
Cut_WB(Tray_Separator_Put_WB);
Put_CT(Block_Put_CT);

}

//產生鍵帽存放托盤上蓋
module CreateKST_Cover()
{
    //建立上蓋
    CreateCover();

}


