# KSTG
鍵帽存放托盤產生器(Keycap Storage Tray Generator)
Version: 2025/5/8

此產生器使用OpenSCAD來打造存放鍵帽的托盤，可以有效運用廢棄盒子，依盒子尺寸與鍵帽尺寸來建立最合適的托盤，讓空間有效運用，並減少廢棄物。\
This generator uses OpenSCAD to design trays for storing keycaps. It allows you to reuse discarded boxes efficiently by creating a tray that fits both the box and keycap dimensions, optimizing space usage and reducing waste.

範例：分隔版樣式\
Examples: Separator Styles

![範例圖示](/img/gallery/01.jpg "")
垂直分隔片樣式：2-短隔板無底板\
Vertical separator style: 2 - Short dividers without base

![範例圖示](/img/gallery/02.jpg "")
垂直分隔片樣式：2-短隔板無底板\
Vertical separator style: 2 - Short dividers without base

![範例圖示](/img/gallery/03.jpg "")
垂直分隔片樣式：1-全部\
Vertical separator style: 1 - Full

範例：放入盒內\
Examples: Inside the Box

![範例圖示](/img/gallery/04.jpg "")
垂直分隔片樣式：0-不需要\
Vertical separator style: 0 - Not needed

![範例圖示](/img/gallery/05.jpg "")
垂直分隔片樣式：1-全部\
搭配手動清除分隔片與底板\
Used with manually removed separators and base plates

![範例圖示](/img/gallery/06.jpg "")
放置時可預留空間，比較好拿取托盤\
Leave some space when placing to make trays easier to retrieve

![範例圖示](/img/gallery/07.jpg "")
裁切同等大小的泡綿\
Cut foam sheets to matching size

![範例圖示](/img/gallery/08.jpg "")
再放上另一層\
Add another layer on top

![範例圖示](/img/gallery/09.jpg "")
放入第三層，如果空間沒有滿，可塞填充物，避免攜帶時鍵帽脫離位置\
Insert a third layer. If there’s extra space, fill with cushioning material to prevent keycaps from shifting during transport

![範例圖示](/img/gallery/10.jpg "")
蓋上盒蓋，完成收納\
Close the lid — storage complete

範例：使用B5文件夾\
Example: Using a B5 Document Folder

![範例圖示](/img/gallery/11.jpg "")
B5文件夾\
B5 Document Folder

![範例圖示](/img/gallery/12.jpg "")\
可完整放入104鍵鍵帽\
Fits all 104 keycaps perfectly

![範例圖示](/img/gallery/13.jpg "")
第二層\
Second layer

![範例圖示](/img/gallery/14.jpg "")
兩層鍵帽組合起來高度剛好\
The height of two keycap layers fits just right

新增項目:\
New Features:

![範例圖示](/img/gallery/15.jpg "")
Choc V1用的Stem插孔\
Stem socket for Choc V1

![範例圖示](/img/gallery/15A.jpg "")
背後有往上凸，可用手指將鍵帽推出來。\
Raised backing allows keycaps to be pushed out with a finger.

![範例圖示](/img/gallery/16.jpg "")
Choc V1用的Stem插孔，一長排的開孔，用於無裙鍵帽，可減少部分使用空間。\
Choc V1 stem socket – a long slot designed for skirtless keycaps, saves some space.

![範例圖示](/img/gallery/17.jpg "")
托盤固定槽榫，多盤時，可以對準堆疊托盤。\
Tray alignment notches – help align and stack multiple trays.

![範例圖示](/img/gallery/18.jpg "")
多盤堆疊範例，可透過固定槽榫固定多個托盤，可由 CreateKST_Cover() 建立上蓋，如果不放盒子內，僅印出堆疊，可以用盒子蓋住，較為完整。\
Example of stacking multiple trays: alignment notches allow trays to be securely stacked. A top cover can be created using CreateKST_Cover(). If not placing the trays inside a box, simply printing and covering the stack with a lid provides a more complete solution.


