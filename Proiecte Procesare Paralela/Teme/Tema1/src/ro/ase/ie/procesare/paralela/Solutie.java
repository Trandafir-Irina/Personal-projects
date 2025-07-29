package ro.ase.ie.procesare.paralela;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

class CalculSumaVarstaThread extends Thread {
    private int nrStudentiInregistrati = 0;
    private double sumaVarsta = 0;
    private int start;
    private int sfarsit;
    private Student[] listaStudenti;

    public CalculSumaVarstaThread(int start, int sfarsit, Student[] listaStudenti) {
        this.start = start;
        this.sfarsit = sfarsit;
        this.listaStudenti = listaStudenti;
    }

    public int getNrStudentiInregistrati() {
        return nrStudentiInregistrati;
    }

    public double getSumaVarsta() {
        return sumaVarsta;
    }

    @Override
    public void run() {
        for(int i = start; i < sfarsit; i++){
            if(listaStudenti[i].verificaEsteInregistrat())
            {
                nrStudentiInregistrati++;
                sumaVarsta += listaStudenti[i].getVarsta();
            }
        }
    }
}

class CalculCelMaiComunPrenumeThread extends Thread {
    private Student[] listaStudenti;
    private int frecventaMaxima = 0;
    private int start;
    private int sfarsit;
    private String celMaiComunPrenume = "";
    private Map<String, Integer> mapFrecventaNume;

    public CalculCelMaiComunPrenumeThread(Student[] listaStudenti, int start, int sfarsit) {
        this.listaStudenti = listaStudenti;
        this.start = start;
        this.sfarsit = sfarsit;
        mapFrecventaNume = new HashMap<>();
    }

    public String getCelMaiComunPrenume() {
        return celMaiComunPrenume;
    }

    public int getFrecventaMaxima() {
        return frecventaMaxima;
    }

    public Map<String, Integer> getMapFrecventaNume() {
        return mapFrecventaNume;
    }

    @Override
    public void run() {
        for(int i = start; i < sfarsit; i++) {
            if(!listaStudenti[i].verificaEsteInregistrat()){
                mapFrecventaNume.put(listaStudenti[i].getPrenume(),
                        mapFrecventaNume.getOrDefault(listaStudenti[i].getPrenume(), 0)+1);

                int nrFrecventa = mapFrecventaNume.get(listaStudenti[i].getPrenume());

                if(nrFrecventa>frecventaMaxima){
                    celMaiComunPrenume = listaStudenti[i].getPrenume();
                    frecventaMaxima = nrFrecventa;
                }
            }
        }
    }
}

class CalculNrStudentiNepromovati extends Thread{
    private Student[] listaStudenti;
    private int nrStudentiNepromovati = 0;
    private int start;
    private int sfarsit;

    public CalculNrStudentiNepromovati(Student[] listaStudenti, int start, int sfarsit) {
        this.listaStudenti = listaStudenti;
        this.start = start;
        this.sfarsit = sfarsit;
    }

    public int getNrStudentiNepromovati() {
        return nrStudentiNepromovati;
    }

    @Override
    public void run() {
        for(int i = start; i < sfarsit; i++){
            if(listaStudenti[i].verificaEsteInregistrat()&&listaStudenti[i].getNota()<5&&
            listaStudenti[i].getVarsta()>20){
                nrStudentiNepromovati++;
            }
        }
    }
}
public final class Solutie {

    /**
     * Calculeaza secvential media varstei studentilor care sunt inregistrati pentru curs
     *
     *
     * @param listaStudenti datele tuturor studentilor
     * @return varsta medie a studentilor inregistrati la acest curs
     */
    public double calculSecventialMediaVarsteiStudentilorInregistrati(
            final Student[] listaStudenti) {
        double mediaVarsta = 0;
        int nrStudentiInregistrati = 0;
        for (Student s: listaStudenti) {
            if(s.verificaEsteInregistrat())
            {
                mediaVarsta += s.getVarsta();
                nrStudentiInregistrati++;
            }
        }
        mediaVarsta = mediaVarsta/nrStudentiInregistrati;
    	return mediaVarsta;
    }

    /**
     * TODO calcul paralel pentru media varstei studentilor care sunt inregistrati pentru curs
     *
     *
     * @param listaStudenti datele tuturor studentilor
     * @return varsta medie a studentilor inregistrati la acest curs
     */
    public double calculParalel_MediaVarsteiStudentilorInregistrati(
            final Student[] listaStudenti) {

        int nrGrupeStudenti = listaStudenti.length/8;

        CalculSumaVarstaThread calculSumaVarstaThread1 = new CalculSumaVarstaThread(
                0,nrGrupeStudenti, listaStudenti);
        CalculSumaVarstaThread calculSumaVarstaThread2 = new CalculSumaVarstaThread(
                nrGrupeStudenti, 2*nrGrupeStudenti, listaStudenti);
        CalculSumaVarstaThread calculSumaVarstaThread3 = new CalculSumaVarstaThread(
                2*nrGrupeStudenti, 3*nrGrupeStudenti, listaStudenti);
        CalculSumaVarstaThread calculSumaVarstaThread4 = new CalculSumaVarstaThread(
                3*nrGrupeStudenti, 4*nrGrupeStudenti, listaStudenti);
        CalculSumaVarstaThread calculSumaVarstaThread5 = new CalculSumaVarstaThread(
                4*nrGrupeStudenti,5*nrGrupeStudenti, listaStudenti);
        CalculSumaVarstaThread calculSumaVarstaThread6 = new CalculSumaVarstaThread(
                5*nrGrupeStudenti, 6*nrGrupeStudenti, listaStudenti);
        CalculSumaVarstaThread calculSumaVarstaThread7 = new CalculSumaVarstaThread(
                6*nrGrupeStudenti, 7*nrGrupeStudenti, listaStudenti);
        CalculSumaVarstaThread calculSumaVarstaThread8 = new CalculSumaVarstaThread(
                7*nrGrupeStudenti, listaStudenti.length, listaStudenti);

        calculSumaVarstaThread1.start();
        calculSumaVarstaThread2.start();
        calculSumaVarstaThread3.start();
        calculSumaVarstaThread4.start();
        calculSumaVarstaThread5.start();
        calculSumaVarstaThread6.start();
        calculSumaVarstaThread7.start();
        calculSumaVarstaThread8.start();

        try {
            calculSumaVarstaThread1.join();
            calculSumaVarstaThread2.join();
            calculSumaVarstaThread3.join();
            calculSumaVarstaThread4.join();
            calculSumaVarstaThread5.join();
            calculSumaVarstaThread6.join();
            calculSumaVarstaThread7.join();
            calculSumaVarstaThread8.join();
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }

        double sumaVarsta = calculSumaVarstaThread1.getSumaVarsta()+calculSumaVarstaThread2.getSumaVarsta()+
                calculSumaVarstaThread3.getSumaVarsta()+calculSumaVarstaThread4.getSumaVarsta()+
                calculSumaVarstaThread5.getSumaVarsta()+calculSumaVarstaThread6.getSumaVarsta()+
                calculSumaVarstaThread7.getSumaVarsta()+calculSumaVarstaThread8.getSumaVarsta();
        int nrStudentiInregistrati = calculSumaVarstaThread1.getNrStudentiInregistrati()+calculSumaVarstaThread2.getNrStudentiInregistrati()+
                calculSumaVarstaThread3.getNrStudentiInregistrati()+calculSumaVarstaThread4.getNrStudentiInregistrati()+
                calculSumaVarstaThread5.getNrStudentiInregistrati()+calculSumaVarstaThread6.getNrStudentiInregistrati()+
                calculSumaVarstaThread7.getNrStudentiInregistrati()+calculSumaVarstaThread8.getNrStudentiInregistrati();

        return sumaVarsta/nrStudentiInregistrati;
    }


    /**
     * Calcul secvential al celui mai comun prenume pentru studentii care nu sunt inregistrati la curs
     *
     *
     * @param studentArray datele tuturor studentilor
     * @return cel mai comun prenume
     */
    public String calculSecvential_CelMaiComunPrenumePentruStudentiiNeinregistrati(
            final Student[] studentArray) {
        Map<String, Integer> mapFrecventaNume = new HashMap<>();
        String celMaiComunPrenume = "";
        int frecventaMax = 0;

        for (Student s: studentArray) {
            if(!s.verificaEsteInregistrat()) {
                if(!mapFrecventaNume.containsKey(s.getPrenume()))
                {
                    mapFrecventaNume.put(s.getPrenume(), 1);
                } else {
                    int nrFrecventa = mapFrecventaNume.get(s.getPrenume()) + 1;
                    mapFrecventaNume.put(s.getPrenume(), nrFrecventa);
                    if(nrFrecventa>frecventaMax){
                        celMaiComunPrenume = s.getPrenume();
                        frecventaMax = nrFrecventa;
                    }
                }
            }
        }

        return celMaiComunPrenume;
    }

    /**
     * TODO calcul paralel al celui mai comun prenume

     *
     *
     * @param listaStudenti datele tuturor studentilor
     * @return cel mai comun prenume
     */
    public String calculParalel_CelMaiComunPrenumePentruStudentiiNeinregistrati(
            final Student[] listaStudenti) {

        int nrGrupeStudenti = listaStudenti.length/8;
        CalculCelMaiComunPrenumeThread t1 = new CalculCelMaiComunPrenumeThread(listaStudenti,
                0, nrGrupeStudenti);
        CalculCelMaiComunPrenumeThread t2 = new CalculCelMaiComunPrenumeThread(listaStudenti,
                nrGrupeStudenti, 2*nrGrupeStudenti);
        CalculCelMaiComunPrenumeThread t3 = new CalculCelMaiComunPrenumeThread(listaStudenti,
                2*nrGrupeStudenti, 3*nrGrupeStudenti);
        CalculCelMaiComunPrenumeThread t4 = new CalculCelMaiComunPrenumeThread(listaStudenti,
                3*nrGrupeStudenti, 4*nrGrupeStudenti);
        CalculCelMaiComunPrenumeThread t5 = new CalculCelMaiComunPrenumeThread(listaStudenti,
                4*nrGrupeStudenti, 5*nrGrupeStudenti);
        CalculCelMaiComunPrenumeThread t6 = new CalculCelMaiComunPrenumeThread(listaStudenti,
                5*nrGrupeStudenti, 6*nrGrupeStudenti);
        CalculCelMaiComunPrenumeThread t7 = new CalculCelMaiComunPrenumeThread(listaStudenti,
                6*nrGrupeStudenti, 7*nrGrupeStudenti);
        CalculCelMaiComunPrenumeThread t8 = new CalculCelMaiComunPrenumeThread(listaStudenti,
                7*nrGrupeStudenti, listaStudenti.length);
        List<CalculCelMaiComunPrenumeThread> listaThreads = new ArrayList<>();
        listaThreads.add(t1);
        listaThreads.add(t2);
        listaThreads.add(t3);
        listaThreads.add(t4);
        listaThreads.add(t5);
        listaThreads.add(t6);
        listaThreads.add(t7);
        listaThreads.add(t8);

        for(CalculCelMaiComunPrenumeThread t: listaThreads) {
            t.start();
        }

        for(CalculCelMaiComunPrenumeThread t: listaThreads) {
            try {
                t.join();
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }
        }

        int maxFrecventa = 0;
        String prenumeleCelMaiComun = "";
        HashMap<String, Integer> mapFrecvPrenume = new HashMap<>();

        for(CalculCelMaiComunPrenumeThread t: listaThreads) {
            for(var e: t.getMapFrecventaNume().entrySet()){
                if(!mapFrecvPrenume.containsKey(e.getKey()))
                {
                    mapFrecvPrenume.put(e.getKey(), e.getValue());
                } else {
                    int nrFrecventa = mapFrecvPrenume.get(e.getKey()) + e.getValue();
                    mapFrecvPrenume.put(e.getKey(), nrFrecventa);
                    if(nrFrecventa>maxFrecventa){
                        prenumeleCelMaiComun = e.getKey();
                        maxFrecventa = nrFrecventa;
                    }
                }
            }
        }

        return prenumeleCelMaiComun;
    }

    /**
     * Determina secvential numarul studentilor care au picat examenul si care au o varsta > 20 ani
     * Un student a picat examenul daca are o nota < 5
     *
     *
     * @param listaStudenti Student data for the class.
     * @return Number of failed grades from students older than 20 years old.
     */
    public int calculSecvential_NumarulStudentiNepromovatiCuVarstaPeste20(
            final Student[] listaStudenti) {
        int nrStudentiPicati = 0;
    	for(Student s:listaStudenti){
            if(s.verificaEsteInregistrat()&&s.getNota()<5&&s.getVarsta()>20)
                nrStudentiPicati++;
        }
        return nrStudentiPicati;
    }

    /**
     * TODO Determina paralel numarul studentilor care au picat examenul si care au o varsta > 20 ani
     * Un student a picat examenul daca are o nota < 5
     *
     * Trebuie utilizate cel putin 2 thread-uri
     *
     * @param studentArray Student data for the class.
     * @return Number of failed grades from students older than 20 years old.
     */
    public int calculParalel_NumarulStudentiNepromovatiCuVarstaPeste20(
            final Student[] studentArray) {
        int nrGrupeStudenti = studentArray.length/8;
        CalculNrStudentiNepromovati t1 = new CalculNrStudentiNepromovati(studentArray, 0, nrGrupeStudenti);
        CalculNrStudentiNepromovati t2 = new CalculNrStudentiNepromovati(studentArray, nrGrupeStudenti,
                2*nrGrupeStudenti);
        CalculNrStudentiNepromovati t3 = new CalculNrStudentiNepromovati(studentArray, 2*nrGrupeStudenti,
                3*nrGrupeStudenti);
        CalculNrStudentiNepromovati t4 = new CalculNrStudentiNepromovati(studentArray, 3*nrGrupeStudenti,
                4*nrGrupeStudenti);
        CalculNrStudentiNepromovati t5 = new CalculNrStudentiNepromovati(studentArray, 4*nrGrupeStudenti,
                5*nrGrupeStudenti);
        CalculNrStudentiNepromovati t6 = new CalculNrStudentiNepromovati(studentArray, 5*nrGrupeStudenti,
                6*nrGrupeStudenti);
        CalculNrStudentiNepromovati t7 = new CalculNrStudentiNepromovati(studentArray, 6*nrGrupeStudenti,
                7*nrGrupeStudenti);
        CalculNrStudentiNepromovati t8 = new CalculNrStudentiNepromovati(studentArray, 7*nrGrupeStudenti,
                8*nrGrupeStudenti);

        t1.start();
        t2.start();
        t3.start();
        t4.start();
        t5.start();
        t6.start();
        t7.start();
        t8.start();

        try {
            t1.join();
            t2.join();
            t3.join();
            t4.join();
            t5.join();
            t6.join();
            t7.join();
            t8.join();
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }

        return t1.getNrStudentiNepromovati()+t2.getNrStudentiNepromovati()+t3.getNrStudentiNepromovati()+
                t4.getNrStudentiNepromovati()+t5.getNrStudentiNepromovati()+t6.getNrStudentiNepromovati()+
                t7.getNrStudentiNepromovati()+t8.getNrStudentiNepromovati();
    }
}
