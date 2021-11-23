#define SIZE 10
#define TRUE 1
#define FALSE 0
void main(void)
{
    static int lista[SIZE];
    int houveTroca, i, aux;
 // inserir aqui o código para leitura de valores e
 // preenchimento do array
    int* p;
    p = lista;
    for(i = 0; i < SIZE; i++)
    {
        printf("\nIntroduza um numero: ");
        scanf("%d", p);
    
    }
    do
    {
        houveTroca = FALSE;
        for (i=0; i < SIZE-1; i++)
        {
            if (lista[i] > lista[i+1])
            {
                aux = lista[i];
                lista[i] = lista[i+1];
                lista[i+1] = aux;
                houveTroca = TRUE;
            }
        }
    } while (houveTroca==TRUE);

for(p = lista; p < lista + SIZE; p++)
 {
 printf("%d" ,lista[i] ); // Imprime o conteúdo da posição do
                    // array cujo endereço é "p"
 printf("; ");
 }
} 