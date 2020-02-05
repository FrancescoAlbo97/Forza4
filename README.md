# Forza4

Progetto di Intelligenza Artificiale volto a realizzare un sistema in grado di giocare a Forza 4, senza sfruttare alcuna euristica specifica del gioco e facendo uso della teoria genetica, assieme ad un sistema con tornei, per allenarsi e imparare nuove condizioni.

## Utilizzo

Per fare uso del programma, è necessario avere un motore in grado di interpretare il linguaggio PROLOG (preferibilmente swipl). Per usare le funzionalità dell'applicazione è sufficiente includere il file *main.pl* durante l'esecuzione dell'engine PROLOG. 

```?- [main].```

Dopo aver incluso il file, sarà quindi possibile utilizzare le funzionalità del programma. In particolare:

- Chiamando la funzione ```forza4``` verrà avviato il programma che, inserita una conoscenza di partenza in seguito ad un prompt, permetterà ad un umano di giocare contro l'intelligenza artificiale, che fa uso di quella conoscenza per scegliere la sua mossa.
- Chiamando la funzione ```impara_da_solo``` viene attivata una funzione di allenamento tra cpu, facendo uso di una memoria di riferimento che allenerà il sistema (modificabile liberamente nel programma)

### Grafico delle conoscenze

Dopo aver avviato il programma tramite la funzione ```forza4``` è possibile, oltre ad iniziare il gioco contro la cpu, anche utilizzare un comando per presentare un grafico che mostrerà lo storico della conoscenza della cpu, facendo uso di un programma Python che esegue il parsing dello storico e lo mostra graficamente. Bisogna notare, tuttavia, che di default il grafico mostra solo le conoscenze che si presentano per più di 3 partite consecutive, per cui è consigliabile effettuare diverse partite prima di utilizzare questa funzionalità.

**NOTA: Verificare di avere Python installato sul terminale, insieme ai package matplotlib e mpldatacursor, e assicurarsi che il path all'eseguibile Python sia corretto. In caso contrario la funzionalità del grafico potrebbe non funzionare correttamente.**

### Gioco

Dopo aver iniziato il gioco contro una cpu verrà mostrata una CLI al giocatore, che gli permetterà di vedere la partita attuale e di scegliere la colonna su cui inserire il gettone. In questa fase è anche possibile correggere la memoria del computer, inserendo come mossa un numero di due cifre, in cui:

- La prima cifra rappresenta la mossa che la cpu avrebbe dovuto fare, invece di quella che ha eseguito
- La seconda cifra rappresenta la mossa che l'umano intende fare come mossa successiva.

### Allenamento

Dopo la fase di gioco, parte la fase di allenamento che, tramite un sistema che fa uso di un sistema a tornei e della teoria genetica, restituisce un nuovo giocatore con una memoria aggiornata, permettendo al giocatore di giocare contro la nuova memoria. Prima dell'inizio dell'allenamento, il programma chiederà al giocatore quante generazioni utilizzare per l'allenamento. 

## Esempio di allenamento

Di seguito viene riportata, a titolo di esempio, una conoscenza generata tramite un allenamento della durata di 40 partite, partendo da una conoscenza iniziale e facendo giocare l'agente contro un altro agente, dotato di conoscenza iniziale e con profondità di esplorazione pari a 4:

```[[-26,b,0,0,c,0,2],[22,a,0,0,c,4,-4],[22,a,0,0,h,2,1],[-47,b,0,0,c,0,1],[27,a,0,0,a,1,0,b,1,5],[-26,b,0,0,c,6,4],[40,a,0,0,c,4,0],[27,b,0,0,h,1,0],[-28,b,0,0,c,5,5],[28,a,0,0,h,3,4],[-28,b,0,0,b,1,3,h,3,3,c,3,6],[27,b,0,0,b,1,3,a,2,3],[42,a,0,0,a,0,1],[29,a,0,0,h,1,0,b,2,4],[-39,b,0,0,b,4,1],[30,b,0,0,c,1,1],[-29,a,0,0,a,0,-3,h,1,-1,h,2,-2,a,3,-3],[42,a,0,0,c,1,5,c,1,6],[-32,a,0,0,a,1,1,a,2,2,h,3,3,h,3,2],[-23,b,0,0,a,3,-1],[33,a,0,0,a,4,3],[40,a,0,0,b,3,-2],[46,b,0,0,c,7,0],[-30,b,0,0,h,3,3],[32,a,0,0,a,1,-1,h,2,-2,a,3,-3],[34,h,0,0,h,1,1,a,2,2,a,3,3],[-38,a,0,0,a,1,-1,a,2,-2,h,3,-3,h,3,-4],[27,b,0,0,a,1,3],[-22,b,0,0,c,5,3],[-45,a,0,0,c,5,-6],[36,b,0,0,c,2,-2],[34,b,0,0,c,2,3],[-24,a,0,0,a,0,1,c,3,0],[-29,b,0,0,c,6,-3],[39,h,0,0,a,1,-1,a,1,0,a,2,0,h,3,0],[36,a,0,0,c,3,-1],[-39,a,0,0,h,1,0,h,1,-1,a,2,0,a,3,0],[30,b,0,0,c,5,-3],[37,a,0,0,a,1,0,h,2,0,a,3,0],[37,b,0,0,a,1,-1],[-34,a,0,0,c,6,-5],[-29,a,0,0,a,0,4],[35,a,0,0,h,2,0],[32,b,0,0,b,1,3],[-47,a,0,0,a,1,0,h,2,0,h,2,-1,a,3,0],[-37,a,0,0,c,2,-6],[-27,b,0,0,h,0,4,a,3,-1],[47,h,0,0,a,1,1,a,2,2,a,3,3],[50,a,0,0,a,1,0,a,2,0,a,3,0],[18,a,0,0,b,5,5],[29,b,0,0,a,3,-1,c,5,-4],[41,b,0,0,b,1,3,h,3,2],[-45,b,0,0,a,2,3],[-37,a,0,0,h,1,1,h,1,0,a,2,2,a,3,3],[47,h,0,0,a,1,0,h,2,0,a,3,0],[-47,a,0,0,c,6,6],[37,a,0,0,h,2,-2],[-42,a,0,0,a,2,-3],[47,b,0,0,h,0,4],[34,a,0,0,c,1,5,a,2,4],[-26,b,0,0,c,4,5],[-37,a,0,0,c,1,-4],[38,h,0,0,a,1,1,h,2,2,a,3,3],[-28,b,0,0,a,1,0],[-25,a,0,0,a,3,0],[37,h,0,0,a,1,0,a,2,0,h,3,0],[45,a,0,0,h,1,-1,h,2,-2,a,3,-3],[50,a,0,0,a,-1,1,a,-2,2,a,-3,3],[44,a,0,0,c,1,6],[-34,a,0,0,a,1,-1,b,2,-3,a,2,-2,h,3,-3,h,3,-4],[-25,b,0,0,b,0,3,h,3,2],[30,a,0,0,a,1,0,h,2,0,h,3,0],[-34,b,0,0,h,0,3,c,7,1],[34,h,0,0,a,1,-1,a,1,1,h,2,-2,a,3,-3],[39,a,0,0,a,1,1,h,2,2,a,3,3],[23,a,0,0,a,0,4,a,1,5],[-46,a,0,0,a,1,-1,h,2,-2,h,2,-3,a,3,-3],[41,a,0,0,a,1,1,b,3,-2],[32,b,0,0,b,2,2],[-26,b,0,0,a,0,-5,c,0,1],[24,a,0,0,a,1,5],[-34,b,0,0,b,0,3],[48,b,0,0,c,7,1],[50,a,0,0,a,1,1,a,2,2,a,3,3],[-24,a,0,0,c,1,0],[47,b,0,0,b,1,-4],[-48,a,0,0,a,1,1,h,2,2,h,2,1,a,3,3],[27,a,0,0,a,1,0,h,2,0,b,3,-2,h,3,0],[50,a,0,0,a,0,1,a,0,2,a,0,3],[38,b,0,0,c,2,0],[-27,a,0,0,h,4,3],[-35,a,0,0,b,2,-1],[-5,b,0,0,h,0,3],[30,b,0,0,c,5,-1],[-36,a,0,0,c,6,0],[-29,a,0,0,b,1,5],[-35,b,0,0,b,1,3,c,3,6],[25,a,0,0,h,1,0,a,2,0,a,3,0],[37,b,0,0,c,0,6],[37,b,0,0,c,1,-6],[-42,b,0,0,c,7,-3],[26,a,0,0,a,2,4],[29,b,0,0,c,2,2],[23,b,0,0,b,2,-1],[-23,a,0,0,b,3,1],[38,h,0,0,a,1,-1,a,2,-2,a,3,-3],[-48,a,0,0,c,3,-4],[-37,b,0,0,b,1,3,c,2,-1],[-29,a,0,0,c,4,-6],[-47,b,0,0,h,3,2],[34,a,0,0,a,1,0,a,2,0,h,3,0],[30,a,0,0,b,2,-4],[39,h,0,0,a,1,-1,h,2,-2,a,3,-3],[-47,a,0,0,c,5,6],[20,a,0,0,a,0,1,a,1,1,h,2,2,a,3,3],[30,b,0,0,h,1,-4],[-39,b,0,0,c,2,4],[25,a,0,0,c,1,6,h,2,0],[33,a,0,0,a,1,0,h,1,1],[-21,b,0,0,h,4,1],[-25,b,0,0,a,0,1],[47,b,0,0,c,1,-1],[-19,b,0,0,c,2,-1],[30,a,0,0,c,1,-2],[39,a,0,0,c,1,5],[36,b,0,0,h,0,3,a,3,3],[-21,a,0,0,a,0,-3,b,2,-4],[-31,a,0,0,b,6,3],[-29,b,0,0,h,4,2],[34,a,0,0,a,1,1,a,2,2,h,3,3],[-36,b,0,0,b,3,1],[-9,b,0,0,c,4,-1],[-34,a,0,0,h,2,-4],[22,a,0,0,h,0,2],[-33,a,0,0,a,1,-2],[26,b,0,0,h,5,5,c,7,0],[-22,a,0,0,c,4,6],[39,b,0,0,c,3,-3],[47,a,0,0,a,1,-1,a,2,-2,h,3,-3],[28,a,0,0,a,1,1],[-35,b,0,0,a,2,3,c,2,4],[30,b,0,0,c,1,-1,c,5,3],[-22,a,0,0,c,1,-3],[-17,h,0,0,h,0,-1,a,1,-1,a,2,-2,a,3,-3],[45,a,0,0,h,1,0,h,2,0,a,3,0],[29,b,0,0,c,2,-1,a,3,3],[-29,b,0,0,a,0,5],[-11,a,0,0,b,4,2],[27,a,0,0,a,2,1],[36,b,0,0,h,5,5],[-34,b,0,0,a,2,-2],[40,b,0,0,a,3,3],[30,h,0,0,a,1,0,a,2,0,a,3,0],[16,b,0,0,a,0,-5],[35,a,0,0,h,1,1,a,2,2,h,3,3],[-31,a,0,0,c,7,2],[31,b,0,0,c,3,6],[-38,b,0,0,b,0,-4],[-20,a,0,0,b,4,0],[23,b,0,0,c,5,-4],[42,a,0,0,h,1,1,a,2,2,a,3,3],[28,a,0,0,h,1,-1,a,2,-2,a,3,-3],[44,b,0,0,h,2,2],[34,h,0,0,h,1,-1,a,2,-2,a,3,-3],[-18,a,0,0,a,0,-5],[-41,a,0,0,h,1,1],[-22,a,0,0,h,1,0,c,1,6]]```
