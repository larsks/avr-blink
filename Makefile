DEVICE     = atmega328p
CLOCK      = 16000000
FUSE_LOW   = 0x64
FUSE_HIGH  = 0xdf
FUSE_EXT   = 0xff
FUSES      = -U lfuse:w:$(FUSE_LOW):m -U hfuse:w:$(FUSE_HIGH):m -U efuse:w:$(FUSE_EXT):m
AVR_PORT   = /dev/ttyACM0
PORT       = -P $(AVR_PORT)
PROGRAMMER = -c arduino
AVRDUDE    = avrdude
CC         = avr-gcc
OBJCOPY    = avr-objcopy
AVRDUDE    = avrdude -v $(PORT) $(PROGRAMMER) -p $(DEVICE)

ifeq ($(DEBUG), 1)
	OPTFLAG = -Og -g
else
	OPTFLAG = -Os
endif

CFLAGS     += -Wall $(OPTFLAG) -DF_CPU=$(CLOCK) -mmcu=$(DEVICE)

all: blink.hex

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

%.s: %.c
	$(CC) $(CFLAGS) -S $< -o $@

%.elf: %.o
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^ $(LIBS)

%.hex: %.elf
	$(OBJCOPY) -j .text -j .data -O ihex $< $@


flash:	$(PROGNAME).hex
	$(AVRDUDE) -U flash:w:$<:i

fuse:
	$(AVRDUDE) $(FUSES)

boardinfo:
	$(AVRDUDE)

make: flash fuse

clean:
	rm -f $(PROGNAME).o $(PROGNAME).elf $(PROGNAME).hex
