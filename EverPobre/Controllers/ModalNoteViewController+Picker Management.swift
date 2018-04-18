//
//  ModalNoteViewController+Picker Management.swift
//  EverPobre
//
//  Created by Adolfo Fernández on 18/4/18.
//  Copyright © 2018 Adolfo Fernandez. All rights reserved.
//

import UIKit

extension ModalNoteViewController {
    
    // MARK: - Picker Notebook default management
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == notebookDefaultPicker {
            return fetchedResultControllerDefault.fetchedObjects!.count
        }
        else if pickerView == notebookToDeletePicker {
            return fetchedResultControllerDelete.fetchedObjects!.count
        }
        else if pickerView == notebookToTransferPicker {
            return fetchedResultControllerTransfer.fetchedObjects!.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 300
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 20.0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let indexPath = IndexPath(row: row,  section: 0)
        var notebook = Notebook()
        if pickerView == notebookDefaultPicker {
            notebook   = self.fetchedResultControllerDefault.object(at: indexPath as IndexPath) as Notebook
        }
        else if  pickerView == notebookToDeletePicker {
            notebook  = self.fetchedResultControllerDelete.object(at: indexPath as IndexPath) as Notebook
        }
        else if  pickerView == notebookToTransferPicker {
            notebook  = self.fetchedResultControllerTransfer.object(at: indexPath as IndexPath) as Notebook
        }
        return notebook.title
    }
}
