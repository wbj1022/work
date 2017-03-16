.class public Lcom/ijinshan/cleaner/c/c;
.super Ljava/lang/Object;
.source "JunkBlurryPicUtil.java"


# direct methods
.method static synthetic a(Landroid/graphics/Bitmap;)D
    .locals 2

    .prologue
    .line 15
    invoke-static {p0}, Lcom/ijinshan/cleaner/c/c;->b(Landroid/graphics/Bitmap;)D

    move-result-wide v0

    return-wide v0
.end method


/*
 *拉普拉斯算子计算模糊度：                                                              |0,  1, 0|
 *1.将图像转化成灰度图像                                                                |1, -4, 1|
 *2.当前像素点  权值 = 上下左右个像素点灰度值之和 - 4 X 当前像素点灰度值                |0,  1, 0|
 *3.|权值| > 100, 统计清晰像素点数+1；
 *清晰像素点数值越大，越清晰。
 */
.method private static a(Landroid/graphics/Bitmap;II)D
    .locals 11

    .prologue
    .line 92
    const/4 v0, 0x3                  //v0 = 3;

    new-array v7, v0, [[I            //v7 = new int[3][]{}; 二维数组

    const/4 v0, 0x0                  //v0 = 0;

    const/4 v1, 0x3                  //v1 = 3;

    new-array v1, v1, [I             //v1 = new int[3]{};  一维数组

    fill-array-data v1, :array_0     //v1 = array_0;  {0, 1, 0}

    aput-object v1, v7, v0           //v7[v0] = v1;  -->  v7[0] = v1; {0, 1, 0}

    const/4 v0, 0x1                  //v0 = 1;

    const/4 v1, 0x3                  //v1 = 3;

    new-array v1, v1, [I             //v1 = new int[3]{};

    fill-array-data v1, :array_1     //v1 = array_1; {1, -4, 1}

    aput-object v1, v7, v0           //v7[v0] = v1;  v7[1] = v1;   {1, -4, 1}

    const/4 v0, 0x2                  //v0 = 2;

    const/4 v1, 0x3                  //v1 = 3;

    new-array v1, v1, [I             //v1 = new int[3]{};

    fill-array-data v1, :array_2     //v1 = array_2; {0, 1, 0}

    aput-object v1, v7, v0           //v7[v0] = v1;  v7[2] = v1;   {0, 1, 0}


////////////////////////////////
//v7 = |0,  1, 0|
//     |1, -4, 1|
//     |0,  1, 0|
////////////////////////////////
    .line 95
    const-wide/16 v2, 0x0            //v2 = 0;

    .line 97
    const/4 v0, 0x1                  //v0 = 1;

    move v6, v0                      //v6 = v0 = 1;

    :goto_0
    add-int/lit8 v0, p2, -0x1        //v0 = p2 - 1

    if-ge v6, v0, :cond_5            //v6 >= v0 -->跳到cond_5    for (v6 = 1; v6 < p2 - 1; v6++)

    .line 100
    const/4 v0, 0x1                  //v0 = 1;

    move v5, v0                      //v5 = v0 = 1;

    move-wide v0, v2                 //v0 = v2;

    :goto_1
    add-int/lit8 v2, p1, -0x1        //v2 = p1 - 1;

    if-ge v5, v2, :cond_4            //v5 >= v2-->跳到cond_4    for (v5 = 1; v5 < p1 - 1; v5++)

    .line 102
    const/4 v3, 0x0                  //v3 = 0;

    .line 103
    const/4 v2, -0x1                 //v2 = -1

    move v4, v2                      //v4 = v2 = -1

    :goto_2
    const/4 v2, 0x1                  //v2 = 1;

    if-gt v4, v2, :cond_1            //v4 > v2 -->跳到cond_1

    .line 106
    const/4 v2, -0x1                 //v2 = -1;

    :goto_3
    const/4 v8, 0x1                  //v8 = 1;

    if-gt v2, v8, :cond_0            //v2 > v8 -->跳到cond_0

    .line 109
    add-int v8, v5, v2              //v8 = v5 + v2;

    add-int v9, v6, v4              //v9 = v6 + v4;

    invoke-virtual {p0, v8, v9}, Landroid/graphics/Bitmap;->getPixel(II)I

    move-result v8                 //v8 = p0.getPixel(v8, v9);

    invoke-static {v8}, Lcom/ijinshan/cleaner/model/b/a;->a(I)I        //rgb--->gray

    move-result v8                 //v8就是灰度

    .line 111
    add-int/lit8 v9, v2, 0x1       //v9 = v2 + 1;

////////////////////////////////
//v7 = |0,  1, 0|
//     |1, -4, 1|
//     |0,  1, 0|
////////////////////////////////

    aget-object v9, v7, v9         //v9 = v7[v9];  v9 = v7[v2 + 1] = v7[0] = {0, 1, 0};

    add-int/lit8 v10, v4, 0x1      //v10 = v4 + 1 = 0;

    aget v9, v9, v10               //v9 = v9[v10] = v9[0] = 0;

    mul-int/2addr v8, v9           //v8 = v8 * v9 = 0;

    add-int/2addr v3, v8           //v3 += v8;

    .line 106
    add-int/lit8 v2, v2, 0x1       //v2 ++;

    goto :goto_3

    .line 103
    :cond_0
    add-int/lit8 v2, v4, 0x1       //v4++;

    move v4, v2                    //v4 = v2;

    goto :goto_2

    .line 121
    :cond_1
    const/16 v2, 0x64              //v2 = 100;

    if-gt v3, v2, :cond_2          //v3 > v2 --->cond_2         if (v3 > 100 || v3 < -100)

    const/16 v2, -0x64             //v2 = -100;

    if-ge v3, v2, :cond_3          //v3 >= v2 --->cond_3        if (v3 >= -100 && v3 <= 100)

    .line 122
    :cond_2
    const-wide/high16 v2, 0x3ff0000000000000L    # 1.0       //v2 = 1.0;

    add-double/2addr v0, v2        //v0  = v0 + v2 = v0 + 1.0 = v0++;

    .line 100
    :cond_3
    add-int/lit8 v2, v5, 0x1       //v2 = v5 + 1;

    move v5, v2                    //v5 = v2; v5++;

    goto :goto_1

    .line 97
    :cond_4
    add-int/lit8 v2, v6, 0x1       //v2 = v6 + 1;

    move v6, v2                    //v6 = v2; v6++;

    move-wide v2, v0               //v2 = v0;

    goto :goto_0

    .line 129
    :cond_5
    return-wide v2                 //return v2;

    .line 92
    nop

    :array_0                       //array_0 = {0, 1, 0};
    .array-data 4               
        0x0
        0x1
        0x0
    .end array-data

    :array_1                       //array_0 = {1, -4, 1};
    .array-data 4
        0x1
        -0x4
        0x1
    .end array-data

    :array_2                       //array_0 = {0, 1, 0};
    .array-data 4
        0x0
        0x1
        0x0
    .end array-data
.end method

.method public static a(Lcom/cleanmaster/photomanager/MediaFile;)D
    .locals 3

    .prologue
    .line 29
    invoke-virtual {p0}, Lcom/cleanmaster/photomanager/MediaFile;->m()J

    move-result-wide v0

    .line 31
    new-instance v2, Lcom/ijinshan/cleaner/c/d;

    invoke-direct {v2, v0, v1}, Lcom/ijinshan/cleaner/c/d;-><init>(J)V

    .line 32
    invoke-virtual {v2}, Lcom/ijinshan/cleaner/c/d;->start()V

    .line 35
    const-wide/16 v0, 0x1388                      //5000

    :try_start_0
    invoke-virtual {v2, v0, v1}, Lcom/ijinshan/cleaner/c/d;->join(J)V
    :try_end_0
    .catch Ljava/lang/InterruptedException; {:try_start_0 .. :try_end_0} :catch_0

    .line 39
    :goto_0
    invoke-static {v2}, Lcom/ijinshan/cleaner/c/d;->a(Lcom/ijinshan/cleaner/c/d;)D

    move-result-wide v0

    return-wide v0

    .line 36
    :catch_0
    move-exception v0

    goto :goto_0
.end method


/*
 * 按长宽比缩放成最长边为64像素的图像;
 */
.method private static b(Landroid/graphics/Bitmap;)D                 
    .locals 4

    .prologue
    const/16 v0, 0x40                                                  //v0 = 64

    .line 72
    invoke-virtual {p0}, Landroid/graphics/Bitmap;->getWidth()I        

    move-result v1                                                     //v1 = bitmap.getWidth();

    int-to-float v1, v1                                                

    invoke-virtual {p0}, Landroid/graphics/Bitmap;->getHeight()I      

    move-result v2

    int-to-float v2, v2                                                //v2 = bitmap.getHeight();

    div-float/2addr v1, v2                                             //v1 = v1 / v2 = w / h;

    .line 73
    const/high16 v2, 0x3f800000    # 1.0f                              //v2 = 1.0

    cmpl-float v2, v1, v2                                              //if (v1 > v2)  v2 = -1; 
                                                                       //if (v1 = v2)  v2 = 0;
                                                                       //if (v1 < v2)  v2 = 1;

    if-lez v2, :cond_1                                                 //if v2 <= 0 (width >= height)--->cond_1;
                                                                       //if (v2 > 0)  (width < height)
    .line 75
    int-to-float v2, v0                                                //v2 = v0 = 64;

    mul-float/2addr v1, v2                                             //v1 = v1 * v2 = v1 * 64 = (width / height) * 64;

    invoke-static {v1}, Ljava/lang/Math;->round(F)I                    

    move-result v1                                                     //v1 = Math.round(v1);

    .line 80
    :goto_0
    const/4 v2, 0x0                                                    //v2 = 0

    invoke-static {p0, v1, v0, v2}, Landroid/graphics/Bitmap;->createScaledBitmap(Landroid/graphics/Bitmap;IIZ)Landroid/graphics/Bitmap;

    move-result-object v2                      //v2 = Bitmap.createScaledBitmap(bitmap, 64, 64/(宽高比), false)

    .line 81
    if-nez v2, :cond_2                         //if (v2 != null) -->cond_2

    .line 82
    const-wide/16 v0, 0x0

    .line 88
    :cond_0
    :goto_1
    return-wide v0

    .line 78
    :cond_1    //width > height
    int-to-float v2, v0                                    //v2 = v0 = 64;

    div-float v1, v2, v1                                   //v1 = v2/v1 = 64 / (width / height);

    invoke-static {v1}, Ljava/lang/Math;->round(F)I

    move-result v1                                         //v1 = Math.round(v1);//四舍五入

    move v3, v1                                            //v3 = v1;

    move v1, v0                                            //v1 = v0 = 64;

    move v0, v3                                            //v0 = v3;

    goto :goto_0

    .line 84
    :cond_2
    invoke-static {v2, v1, v0}, Lcom/ijinshan/cleaner/c/c;->a(Landroid/graphics/Bitmap;II)D

    move-result-wide v0

    .line 85
    if-eqz v2, :cond_0

    .line 86
    invoke-virtual {v2}, Landroid/graphics/Bitmap;->recycle()V

    goto :goto_1
.end method
