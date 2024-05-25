import psycopg2
import os
from datetime import date
from decimal import Decimal
from colorama import init, Fore, Style

init(autoreset=True)

def clear():
    """Cancella la console."""
    os.system("clear")

## INSERIRE PARAMETRI CONNESSIONE
def get_connection():
    return psycopg2.connect(
        host="",
        database="",
        user="",
        password=""
    )

def create_table():
    conn = get_connection()
    with conn:
        with conn.cursor() as cur:
            cur.execute("""
                CREATE TABLE IF NOT EXISTS Spese (
                    id SERIAL PRIMARY KEY,
                    data DATE NOT NULL,
                    voce VARCHAR NOT NULL,
                    importo NUMERIC NOT NULL
                )
            """)
            print(f'{Fore.GREEN}Esito della creazione della tabella Spese: {cur.statusmessage}')
            conn.commit()

def insert_spesa(data, voce, importo):
    conn = get_connection()
    with conn:
        with conn.cursor() as cur:
            cur.execute("""
                INSERT INTO Spese (data, voce, importo)
                VALUES (%s, %s, %s)
            """, (data, voce, importo))
            print(f'{Fore.GREEN}Esito dell\'inserimento: {cur.statusmessage}')
            conn.commit()

def view_spese():
    conn = get_connection()
    with conn:
        with conn.cursor() as cur:
            cur.execute("SELECT id, data, voce, importo FROM Spese")
            rows = cur.fetchall()
            print(f'{Fore.GREEN}Esito della selezione di tutte le tuple: {cur.statusmessage}')
            print(Fore.CYAN + '=' * 70)
            patternRiga = "| {:5s} | {:10s} | {:30s} | {:10s} |"
            print(Fore.CYAN + patternRiga.format("ID", "Data", "Voce", "Importo"))
            print(Fore.CYAN + '-' * 70)
            for row in rows:
                print(patternRiga.format(str(row[0]), str(row[1]), row[2], str(row[3])))
            print(Fore.CYAN + '-' * 70)
            return len(rows)

def delete_spesa(spesa_id):
    conn = get_connection()
    with conn:
        with conn.cursor() as cur:
            cur.execute("SELECT COUNT(*) FROM Spese WHERE id = %s", (spesa_id,))
            count = cur.fetchone()[0]
            if count == 0:
                print(f'{Fore.RED}ID non trovato.')
            else:
                cur.execute("DELETE FROM Spese WHERE id = %s", (spesa_id,))
                print(f'{Fore.GREEN}Esito della cancellazione: {cur.statusmessage}')
                conn.commit()

def main():
    create_table()
    while True:
        try:
            clear()
            print(Fore.BLUE + Style.BRIGHT + "Gestione della tabella Spese")
            print(Fore.YELLOW + Style.BRIGHT + "1. Inserire una voce di spesa")
            print(Fore.YELLOW + Style.BRIGHT + "2. Vedere tutte le voci di spesa")
            print(Fore.YELLOW + Style.BRIGHT + "3. Cancellare una voce di spesa")
            print(Fore.RED + Style.BRIGHT + "4. Esci")
            choice = input("Scegli un'opzione: ")
            
            if choice == '1':
                data = input("Inserisci la data (YYYY-MM-DD): ")
                voce = input("Inserisci la voce: ")
                importo = Decimal(input("Inserisci l'importo: "))
                insert_spesa(data, voce, importo)
            elif choice == '2':
                view_spese()
                input("Premi invio per continuare...")
            elif choice == '3':
                num_spese = view_spese()
                if num_spese == 0:
                    print(Fore.RED + "Non ci sono voci di spesa da cancellare.")
                    input("Premi invio per continuare...")
                else:
                    spesa_id = int(input("Inserisci l'ID della voce da cancellare: "))
                    delete_spesa(spesa_id)
                    input("Premi invio per continuare...")
            elif choice == '4':
                print(Fore.RED + "Chiusura del programma...")
                break

        except KeyboardInterrupt:
            print(Fore.RED + "\nChiusura del programma...")
            break

if __name__ == "__main__":
    main()

