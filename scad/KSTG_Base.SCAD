// Keycaps 存放架產生器
// keycap storage tray generator

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
    cube([BoxSize_L,Tray_Separator_T_L,Tray_Separator_H+Tray_Bottom_T],false);
    
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
        cube([Tray_Separator_T_W,Tray_Separator_L,Tray_Separator_H+Tray_Bottom_T],false);
    //下
    for (i =[1:Tray_VS_Q-1])
        for (j =[1:Tray_HS_Q])
    translate([(Keycaps_Space_L+Tray_Separator_T_W)*i+Tray_Fence_T-Tray_Separator_T_W,(Keycaps_Space_W+Tray_Separator_T_L)*(j-1)+Tray_Fence_T,0]) 
        cube([Tray_Separator_T_W,Tray_Separator_L,Tray_Separator_H+Tray_Bottom_T],false);

    }
// 2 全部
else if(Tray_VS_Type==1) {
    //垂直分隔片    
    for (i =[1:Tray_VS_Q-1])
    translate([(Keycaps_Space_L+Tray_Separator_T_W)*i+Tray_Fence_T-Tray_Separator_T_W,0,0]) 
        cube([Tray_Separator_T_W,BoxSize_W,Tray_Separator_H+Tray_Bottom_T],false);
    
    }
 
//多餘空間處理方式
// 2 角落填補剩餘空間
 if (ExtraSpaceUse == 2) {
    //左下下
    translate([0,-ES_W,0]) 
        cube([Keycaps_Space_W,ES_W,ES_H],false);
    //左下左
     translate([-ES_L,0,0]) 
        cube([ES_L,Keycaps_Space_L,ES_H],false);    

     //左上左
     translate([-ES_L,BoxSize_W-Keycaps_Space_L,0]) 
        cube([ES_L,Keycaps_Space_L,ES_H],false); 
     //左上上
     translate([0,BoxSize_W,0]) 
        cube([Keycaps_Space_W,ES_W,ES_H],false);
     //右下右
     translate([BoxSize_L,0,0]) 
        cube([ES_L,Keycaps_Space_L,ES_H],false);    
     //右下下
     translate([BoxSize_L-Keycaps_Space_W,-ES_W,0]) 
        cube([Keycaps_Space_W,ES_W,ES_H],false);
     //右上右
     translate([BoxSize_L,BoxSize_W-Keycaps_Space_L,0]) 
        cube([ES_L,Keycaps_Space_L,ES_H],false);    
     //右上上
     translate([BoxSize_L-Keycaps_Space_W,BoxSize_W,0]) 
        cube([Keycaps_Space_W,ES_W,ES_H],false);
        
    }
     
// 四角落立柱
  
Tray_Column_T_L = Tray_Column_T > Tray_Fence_T + ES_L ?  Tray_Fence_T + ES_L : Tray_Column_T ;

Tray_Column_T_W = Tray_Column_T > Tray_Fence_T + ES_W ?  Tray_Fence_T + ES_W : Tray_Column_T ;

// 左下下
translate([0,Tray_Fence_T-Tray_Column_T_W,0]) 
    cube([Tray_Column_L,Tray_Column_T_W,Tray_Column_H+Tray_Bottom_T],false);  
// 左下左
translate([Tray_Fence_T-Tray_Column_T_L,Tray_Fence_T-Tray_Column_T_W,0]) 
    cube([Tray_Column_T_L,Tray_Column_L+Tray_Column_T_L,Tray_Column_H+Tray_Bottom_T],false);   
// 右下下
translate([BoxSize_L-Tray_Column_L,Tray_Fence_T-Tray_Column_T_W,0]) 
    cube([Tray_Column_L,Tray_Column_T_W,Tray_Column_H+Tray_Bottom_T],false);
// 右下右
translate([BoxSize_L-Tray_Column_T_L-Tray_Fence_T+Tray_Column_T_L,Tray_Fence_T-Tray_Column_T_W,0]) 
    cube([Tray_Column_T_L,Tray_Column_W,Tray_Column_H+Tray_Bottom_T],false); 
// 左上上     
translate([0,BoxSize_W-Tray_Column_T_W-Tray_Fence_T+Tray_Column_T_W,0]) 
    cube([Tray_Column_L,Tray_Column_T_W,Tray_Column_H+Tray_Bottom_T],false);
// 左上左   
translate([Tray_Fence_T-Tray_Column_T_L,BoxSize_W-Tray_Column_W-Tray_Fence_T+Tray_Column_T_W,0])
    cube([Tray_Column_T_L,Tray_Column_W,Tray_Column_H+Tray_Bottom_T],false); 
//右上上
translate([BoxSize_L-Tray_Column_L,BoxSize_W-Tray_Column_T_W-Tray_Fence_T+Tray_Column_T_W,0]) 
    cube([Tray_Column_L,Tray_Column_T_W,Tray_Column_H+Tray_Bottom_T],false);
//右上右   
translate([BoxSize_L-Tray_Column_T_L-Tray_Fence_T+Tray_Column_T_L,BoxSize_W-Tray_Column_W-Tray_Fence_T+Tray_Column_T_W,0])
    cube([Tray_Column_T_L,Tray_Column_W,Tray_Column_H+Tray_Bottom_T],false); 

//文字標記
if (ShowText==1 && $preview==true) { 
    
for (i =[1:Tray_VS_Q])
    for (j =[1:Tray_HS_Q-1])
    translate([(
    Keycaps_Space_L+Tray_Separator_T_W)*i+Tray_Fence_T-Tray_Separator_T_W-Keycaps_Space_L/1.5,
    (Keycaps_Space_W+Tray_Separator_T_L)*j-(Tray_Bottom_W+Tray_Separator_T_L)/2+Tray_Fence_T,
    Tray_Bottom_T+Tray_Separator_H+1]) 
        color( "Red", 0.3 )text(str(i,",",j),3);

for (i =[1:Tray_VS_Q-1])
    for (j =[1:Tray_HS_Q])
    //-Tray_Bottom_L+Tray_Fence_T-Tray_Separator_T_L-Keycaps_Space_W/2+3
    translate([
    (Keycaps_Space_L+Tray_Separator_T_W)*i+Tray_Fence_T-Tray_Separator_T_W-Keycaps_Space_L/4+3,
    (Keycaps_Space_W+Tray_Separator_T_L)*j-(Tray_Bottom_W+Tray_Separator_T_L)/2+Tray_Fence_T-Keycaps_Space_W/2-1.5,
    Tray_Bottom_T+Tray_Separator_H+1]) 
        color( "Blue", 0.3 )text(str(i,",",j),3);

for (i =[1:Tray_VS_Q-1])
    for (j =[1:Tray_HS_Q-1])
    translate([(
    Keycaps_Space_L+Tray_Separator_T_W)*i+Tray_Fence_T-Tray_Separator_T_W-Keycaps_Space_L/4+3,
    (Keycaps_Space_W+Tray_Separator_T_L)*j-(Tray_Bottom_W+Tray_Separator_T_L)/2+Tray_Fence_T,
    Tray_Bottom_T+Tray_Separator_H+1]) 
        color( "Lime", 0.3 )text(str(i,",",j),3);
    
};

}

module Cut_L(items){
  for (item = items)
        translate([
        (Keycaps_Space_L+Tray_Separator_T_W)*(item[0]-1)+Tray_Fence_T,
        (Keycaps_Space_W+Tray_Separator_T_L)*(item[1])+Tray_Fence_T-Tray_Separator_T_L,
        Tray_Bottom_T]) 
            cube([Keycaps_Space_L,Tray_Separator_T_L,Tray_Separator_H]);
  }  
  
module Cut_W(items){
    for (item = items)
        translate([
        (Keycaps_Space_L+Tray_Separator_T_W)*item[0]+Tray_Fence_T-Tray_Separator_T_W,
        (Keycaps_Space_W+Tray_Separator_T_L)*(item[1]-1)+Tray_Fence_T,
        Tray_Bottom_T]) 
            cube([Tray_Separator_T_W,Keycaps_Space_W,Tray_Separator_H]);
    }    

module Cut_C(items){
    for (item = items)
        translate([
        (Keycaps_Space_L+Tray_Separator_T_W)*(item[0]-1)+Keycaps_Space_L+Tray_Fence_T,
        (Keycaps_Space_W+Tray_Separator_T_L)*(item[1])+Tray_Fence_T-Tray_Separator_T_L,
        Tray_Bottom_T]) 
            cube([Tray_Separator_T_W,Tray_Separator_T_L,Tray_Separator_H]);
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
   
//產生畫面
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
    }
    
//增加項目
Cut_L(Tray_Separator_Put_L);
Cut_W(Tray_Separator_Put_W);
Cut_C(Tray_Separator_Put_C);
Cut_LB(Tray_Separator_Put_LB);
Cut_WB(Tray_Separator_Put_WB);
}