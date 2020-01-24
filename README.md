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