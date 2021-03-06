UNAME := $(shell uname)
ifeq ($(UNAME), Darwin)
  MAKE     = make -r 
  NASK     = $(TOOLPATH)nask
  CC1      = $(TOOLPATH)gocc1 -I$(INCPATH) -I$(ROOTPATH) -Os -Wall -quiet
  GAS2NASK = $(TOOLPATH)gas2nask -a
  OBJ2BIM  = $(TOOLPATH)obj2bim
  MAKEFONT = $(TOOLPATH)makefont
  BIN2OBJ  = $(TOOLPATH)bin2obj
  BIM2HRB  = $(TOOLPATH)bim2hrb
  BIM2BIN  = $(TOOLPATH)bim2bin
  EDIMG    = $(TOOLPATH)edimg
  IMGTOL   = $(TOOLPATH)imgtol.com
  GOLIB    = $(TOOLPATH)golib00 
  COPY     = cp
  DEL      = rm
  TOOLPATH = $(TOOLSDIR)tools/osx/
  INCPATH  = $(TOOLSDIR)tools/osx/haribote/
  COPYSYS  = cat asmhead.bin bootpack.hrb > haribote.sys
else
  MAKE     = $(TOOLPATH)make.exe -r
  NASK     = $(TOOLPATH)nask.exe
  CC1      = $(TOOLPATH)cc1.exe -I$(INCPATH) -I$(ROOTPATH) -Os -Wall -quiet
  GAS2NASK = $(TOOLPATH)gas2nask.exe -a
  OBJ2BIM  = $(TOOLPATH)obj2bim.exe
  MAKEFONT = $(TOOLPATH)makefont.exe
  BIN2OBJ  = $(TOOLPATH)bin2obj.exe
  BIM2HRB  = $(TOOLPATH)bim2hrb.exe
  BIM2BIN  = $(TOOLPATH)bim2bin.exe
  EDIMG    = $(TOOLPATH)edimg.exe
  IMGTOL   = $(TOOLPATH)imgtol.com
  GOLIB    = $(TOOLPATH)golib00.exe 
  COPY     = copy
  DEL      = del
  TOOLPATH = $(TOOLSDIR)tools/windows/
  INCPATH  = $(TOOLSDIR)tools/windows/haribote/
  COPYSYS  = copy /B asmhead.bin+bootpack.hrb haribote.sys
endif

LIBPATH   = $(ROOTPATH)libs/
APILIBPATH = $(LIBPATH)apilib/
STDLIBPATH = $(LIBPATH)stdlibs/

HARIBOTEPATH = $(ROOTPATH)kernel/
TOOLSDIR = $(ROOTPATH)../

APPMKFILE = $(ROOTPATH)app.mk

# 其他指令

%.gas : %.c $(ROOTPATH)apilib.h $(ROOTPATH)stdlibs.h Makefile
	$(CC1) -o $*.gas $*.c

%.nas : %.gas Makefile
	$(GAS2NASK) $*.gas $*.nas

%.obj : %.nas Makefile
	$(NASK) $*.nas $*.obj $*.lst

%.org : %.bim Makefile
	$(BIM2HRB) $*.bim $*.org $(MALLOC)

%.hrb : %.org Makefile
	$(BIM2BIN) -osacmp in:$*.org out:$*.hrb
