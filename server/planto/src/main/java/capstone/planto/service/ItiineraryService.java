package capstone.planto.service;

import capstone.planto.domain.Itiinerary;
import capstone.planto.repository.ItiineraryRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ItiineraryService {

    @Autowired
    private ItiineraryRepository itiineraryRepository;

    public Itiinerary addItiinerary(Itiinerary itiinerary) {
        return itiineraryRepository.save(itiinerary);
    }

    public Optional<Itiinerary> getItiineraryById(Long id) {
        return itiineraryRepository.findById(id);
    }



    public Itiinerary updateItiinerary(Itiinerary itiinerary) {
        return itiineraryRepository.save(itiinerary);
    }

    public void deleteItiinerary(Long id) {
        itiineraryRepository.deleteById(id);
    }

    public List<Itiinerary> getItiinerariesByScheduleID(Long scheduleID) {
        return itiineraryRepository.findByScheduleID(scheduleID);
    }

    public void deleteItiinerariesByScheduleID(Long scheduleID) {
        List<Itiinerary> itiineraries = itiineraryRepository.findByScheduleID(scheduleID);
        for (Itiinerary itiinerary : itiineraries) {
            itiineraryRepository.delete(itiinerary);
        }
    }
}
