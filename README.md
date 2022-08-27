Repositori ini berisi gambaran singkat mengenai satu skripsi berikut dengan alur pengolahan datanya[^1].

# Proses pelembapan *cold surge* serta pengaruhnya terhadap *budget* uap air di Benua Maritim Bagian Barat

## Overview

Oleh karena pengaruhnya yang cukup signifikan di wilayah Indonesia, maka studi mengenai CS menjadi penting untuk terus dilakukan baik dalam perspektif kajian dinamis, fisis, maupun termodinamisnya.

Proses dinamis fenomena CS berikut dampak yang ditimbulkan di daerah tropis dan subtropis hingga lintang tinggi serta interaksinya dengan fenomena lain telah dipahami dengan cukup komprehensif. Namun, proses fisis dan termodinamis dari propagasi CS di Benua Maritim khususnya di bagian barat belum dipahami secara lebih mendalam [^2].

Oleh karena itu, penelitian ini mencoba untuk mengkaji hal tersebut dengan fokus utamanya pada proses pelembapan (transformasi massa udara) massa udara CS serta pengaruh dari propagasi CS terhadap *budget* uap air di Benua Maritim Bagian Barat.

## Metode penelitian

Proses pelembapan CS dianalisis berdasarkan transfer energi dari laut ke atmosfer beserta dengan proses pada kolom vertikal atmosfer. Sementara itu, *budget* uap air dianalisis berdasarkan keseimbangan antara evaporasi minus presipitasi dengan kecenderungan *precipitable water* dan konvergensi transpor uap air.

### Data & alat

Penelitian ini sepenuhnya menggunakan data ECMWF *reanalysis v5*[^3] serta data *sea surface temperature* (SST) dari observasi satelit [^4].

1. *Single level* : per enam jam (00, 06, 12, 18 UTC)
   1. total precipitation $(P)$
   2. evaporation $(E)$
   3. surface latent heat flux (SLHF)
   4. surface sensible heat flux (SSHF)
2. *Pressure level* (1000-100 mb) : per enam jam (00, 06, 12, 18 UTC)
   1. temperature $(T)$
   2. specific humidity $(q)$
   3. horizontal wind component $(u, v)$
   4. vertical velocity $(w)$

Data diolah menggunakan CDO (untuk preprocessing), NCL (alat utama), *spreadsheet* (untuk identifikasi CS & CENS[^5]), dan GrADS (untuk visualisasi).

### Alur pengolahan data

|  ![Diagram alir pengolahan data](diagram/detilolahdata.png)  |
|:--:|
|  *Diagram alir pengolahan data*  |

#### 1. Pre-processing : `(1) CDO`

Data beresolusi enam jam dirata-ratakan menjadi harian menggunakan CDO, memanfaatkan perintah `daymean`.

    daymean inputfile.nc outputfile.nc

#### 2. Mengidentifikasi CS dan CENS : `(2) NCL` & `(3) Spreadsheet`

Rata-rata angin meridional $(v)$ lapisan 925 mb di area 110-116⁰BT dan 8-15⁰LU (105-110⁰BT dan 5⁰LS-0) digunakan untuk mengidentifikasi CS (CENS) -yang kemudian dinamakan sebagai indeks CS dan CENS. Nilai $v$ tersebut diekstrak menggunakan NCL dengan memanfaatkan perintah [`wgt_areaave`](https://www.ncl.ucar.edu/Document/Functions/Built-in/wgt_areaave.shtml).
>*Script* tahap ini terdapat pada file bernama `2_index.ncl`.

CS dan CENS kemudian diidentifikasi secara manual menggunakan *spreadsheet*, aktif apabila nilai indeksnya lebih dari 8 m/s (5 m/s) yang persisten selama enam (empat) hari berturut-turut[^6]. Nilai tertinggi dalam satu episode tersebut kemudian ditandai sebagai H0.

#### 3. Menyeleksi data : `(4) NCL`

Data luaran *pre-processing* kemudian diseleksi berdasarkan kejadian CS dan CENS. Seleksi ini dilakukan selama periode H-10 hingga H+10 dengan H0 merupakan indeks tertinggi dalam satu episode.
>*Script* tahap ini terdapat pada file bernama `3_seldat.ncl`.

#### 4. Mendefinisikan variabel : `(5) NCL` & `(6) NCL`

Terdapat tiga kelompok variabel, sebagai berikut.

##### 1. Transfer energi dari laut ke atmosfer

Tiga variabel: SST, SSHF, dan SLHF. Variabel ini bisa langsung digunakan ke tahap berikutnya.

##### 2. Proses kolom vertikal atmosfer

Empat variabel: *apparent heat source* $(Q_1)$,  *apparent moisture sink* $(Q_2)$, dan integrasinya secara vertikal $(<Q_1>, <Q_2>)$[^7].
>*Script* tahap ini terdapat pada file bernama `4_2_Q1Q2_cscens.ncl` untuk kasus CS dan CENS, serta `4_2_Q1Q2_all.ncl` untuk semua data.

##### 3. *Budget* uap air

Empat variabel: $E$, $P$, kecenderungan *precipitable water* $(\frac{\partial<q>}{\partial t})$, dan konvergensi transpor uap air $(\nabla \cdot <qV>)$[^8].
>*Script* tahap ini terdapat pada file bernama `4_3_mb_cscens.ncl` untuk kasus CS dan CENS, serta `4_3_mb_all.ncl` untuk semua data.

#### 5. Melakukan uji signifikansi : `(7) NCL`

Uji signifikasi statistik dilakukan menggunakan metode uji student-t dua sisi dengan *confidence level* 95%. Uji ini dilakukan untuk semua variabel yang telah didefinisikan sebelumnya. Proses ini diselesaikan dengan memanfaatkan perintah [`ttest`](http://ncl.ucar.edu/Document/Functions/Built-in/ttest.shtml) yang terdapat di NCL.
>*Script* tahap ini terdapat pada file bernama `5_signif.ncl`.

#### 6. Post-processing : `(8) NCL`

Tahap ini dilakukan khususnya untuk mengekstrak nilai rata-rata area untuk tiap-tiap wilayah analisis yang merepresentasikan empat wilayah yaitu Laut Cina Selatan (Region A, RA), Laut Natuna Utara (RB), Selat Karimata (RB), dan Laut Jawa (RD). Tahap ini berlaku untuk semua variabel.
>*Script* tahap ini terdapat pada file bernama `6_vis.ncl`.

#### 7. Visualisasi : `(9) NCL`

Visualisasi sepenuhnya dilakukan menggunakan GrADS dengan luaran dalam bentuk grafik temporal jeda waktu (H-10 s.d. H+10) dan peta spasial.
>*Script* tahap ini terdapat pada file yang berekstensi `*.gs`.

---

| Info | |
|----|----|
|  Penulis  |  Suwignyo Prasetyo  |
|  Pembimbing  |  Dr. Yosafat D. Haryanto, M.Si.  |
|  Penguji 1  | Dr. Aries Kristianto, M.Si. |
|  Penguji 2  | Imma Redha Nugraheni, M.Si. |
| | |

>The complete contents at this repository are under progres.

## Referensi

[^1]: Naskah skripsi lengkap dapat diakses melalui pranala berikut *[otw]*
[^2]: [Chang et al. (2016)](https://journals.ametsoc.org/mono/article-split/doi/10.1175/AMSMONOGRAPHS-D-15-0011.1/28310/Monsoon-Convection-in-the-Maritime-Continent) dan [Yoden et al. (2017)](https://sci-hub.se/https://doi.org/10.1142/9789813200913_0006)
[^3]: Data dapat diakses secara bebas melalui pranala berikut.

    single level : https://cds.climate.copernicus.eu/cdsapp#!/dataset/reanalysis-era5-single-levels.
    
    multi/pressure level : https://cds.climate.copernicus.eu/cdsapp#!/dataset/reanalysis-era5-pressure-levels.

[^4]: Data dapat diakses secara bebas melalui pranala berikut https://cds.climate.copernicus.eu/cdsapp#!/dataset/satellite-sea-surface-temperature.
[^5]: CENS = *cross equatorial northerly surge*, CS yang berpropagasi hingga melintasi garis ekuator.
[^6]: (Chang, dkk., 2005 dan Hattori, dkk., 2011)
[^7]: Lebih lanjut mengenai metode ini, lihat [Yanai, et al. (1973)](https://journals.ametsoc.org/view/journals/atsc/30/4/1520-0469_1973_030_0611_dobpot_2_0_co_2.xml); [Yanai, et al. (1998)](https://journals.ametsoc.org/view/journals/clim/11/3/1520-0442_1998_011_0463_saivoa_2.0.co_2.xml); dan http://ncl.ucar.edu/Applications/wind.shtml.
[^8]: Lebih lanjut mengenai metode ini, lihat [Trenberth, et al. (1995)](https://journals.ametsoc.org/view/journals/clim/8/9/1520-0442_1995_008_2255_eotgam_2_0_co_2.xml) dan http://ncl.ucar.edu/Applications/wind.shtml.