int main(void)
{
    volatile unsigned int marker = 0x12345678u;

    while (1)
    {
        marker++;
    }
}
